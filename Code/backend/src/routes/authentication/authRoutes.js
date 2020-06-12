import { Router } from 'express';
import User from '../../models/user';
import TokenBlacklist from '../../models/tokenBlacklist';
import asyncErrorCatcher from '../../util/asyncErrorCatcher';
import composeErrorResponse from '../../util/composeErrorResponse';
import {
  validateSignupDate,
  validateLoginData,
  validateRequestResetPasswordData,
  validateResetPasswordData,
  verifyTokenEmailData,
  validateChangePasswordReq,
} from './authValidators';
import { createTransporter, sendResetId } from '../../util/emailer';
import authMiddleware from '../../middleware/authMiddleware';
import successResponse from '../../util/successResponse';

const authRouter = Router();
// TODO add routes in here
authRouter.post('/signup', async (req, res) => {
  try {
    const validation = validateSignupDate(req.body);
    if (validation) {
      return res.status(400).send(composeErrorResponse(validation, 400));
    }

    // Create a new user
    const user = new User(req.body);

    // Check user existance
    if (await User.existsByEmail(user.email)) {
      return res
        .status(400)
        .send(
          composeErrorResponse(['A user with that email already exists'], 400)
        );
    }

    // save user
    await user.save();
    // // generate token
    const token = await user.generateAuthToken();
    res.status(201).send({
      token,
      firstName: user.firstName,
      lastName: user.lastName,
      email: user.email,
      phoneNumber: user.phoneNumber,
    });
  } catch (error) {
    res.status(400).send(error);
  }
});

authRouter.post(
  '/login',
  asyncErrorCatcher(async (req, res) => {
    const validation = validateLoginData(req.body);
    if (validation) {
      return res.status(400).send(composeErrorResponse(validation, 400));
    }
    try {
      // Login a registered user
      const { email, password } = req.body;
      const user = await User.findByCredentials(email, password); // TODO this throws error when credentials not good
      if (!user) {
        return res
          .status(401)
          .send(
            composeErrorResponse(
              ['Login failed! Invalid login credentials'],
              401
            )
          );
      }
      const token = await user.generateAuthToken();
      res.send({
        token,
        firstName: user.firstName,
        lastName: user.lastName,
        email: user.email,
        phoneNumber: user.phoneNumber,
      });
    } catch (error) {
      // TODO we shouldn't be here? Empty error something is being thrown
      res.status(400).send(error);
    }
  })
);

// TODO detect if someone tries this one too many times
authRouter.post('/request-reset', async (req, res) => {
  const validation = validateRequestResetPasswordData(req.body);
  if (validation) {
    return res.status(400).send(composeErrorResponse(validation, 400));
  }
  const user = await User.getByEmail(req.body.email);
  if (!user) {
    return res
      .status(400)
      .send(composeErrorResponse(['No user exists with the given email'], 400));
  }

  // Generate id and set it on the user document
  const id = await user.createResetToken();

  // send email
  sendResetId(createTransporter(), user.email, id);

  // Return success to user
  res.status(200).send({ id });
});

authRouter.post('/resend-reset-token', async (req, res) => {
  const validation = validateRequestResetPasswordData(req.body);
  if (validation) {
    return res.status(400).send(composeErrorResponse(validation, 400));
  }

  const user = await User.getByEmail(req.body.email);
  console.log(user);
  // find user that has the reset id (since it's unique uuid)
  if (!user.hasResetToken()) {
    return res
      .status(400)
      .send(
        composeErrorResponse(
          ['You do not have a reset token to start with!'],
          400
        )
      );
  }

  const id = await user.createResetToken();

  sendResetId(createTransporter(), user.email, id);

  return res.status(200).send({ id });
});

// verify-reset-token-email
authRouter.post('/verify-reset-token-email', async (req, res) => {
  const validation = verifyTokenEmailData(req.body);
  if (validation) {
    return res.status(400).send(composeErrorResponse(validation, 400));
  }

  const user = await User.getByEmail(req.body.email);

  // TODO check token is valid
  if (user.resetId !== req.body.resetToken) {
    return res
      .status(401)
      .send(
        composeErrorResponse(
          ['Reset token invalid! Please generate a new one'],
          401
        )
      );
  }

  if (await user.isResetTokenExpired()) {
    return res
      .status(401)
      .send(
        composeErrorResponse(
          ['Token is expired! Please generate a new one'],
          401
        )
      );
  }

  return res.status(200).send(successResponse());
});

authRouter.post('/reset-forgotten-password', async (req, res) => {
  const validation = validateResetPasswordData(req.body);
  if (validation) {
    return res.status(400).send(composeErrorResponse(validation, 400));
  }

  const { email, resetToken, password } = req.body;

  const user = await User.getByEmail(email);

  if (!user) {
    return res
      .status(401)
      .send(composeErrorResponse(['No user was found with that email'], 401));
  }

  // TODO check token is valid
  if (user.resetId !== resetToken) {
    return res
      .status(401)
      .send(
        composeErrorResponse(
          ['Reset token invalid! Please generate a new one'],
          401
        )
      );
  }

  if (await user.isResetTokenExpired()) {
    return res
      .status(401)
      .send(
        composeErrorResponse(
          ['Reset token invalid! Please generate a new one'],
          401
        )
      );
  }

  await user.resetPassword(password);

  return res.status(200).send(successResponse());
});

// Only a logged in user can do these operations d so logged in middleware has to be used
// Using auth middleware here
authRouter.delete('/logout', authMiddleware, async (req, res) => {
  const token = req.token;
  const blackListedToken = new TokenBlacklist({ token });
  await blackListedToken.save();
  res.status(205).send();
});

authRouter.post('/change-password', authMiddleware, async (req, res) => {
  const validation = validateChangePasswordReq(req.body);
  if (validation) {
    return res.status(400).send(composeErrorResponse(validation, 400));
  }
  const { email, oldPassword, newPassword } = req.body;
  const user = await User.getByEmail(email);

  if (!user) {
    return res
      .status(401)
      .send(composeErrorResponse(['No user was found with that email'], 401));
  }

  if (!(await user.verifyPassword(oldPassword))) {
    return res
      .status(401)
      .send(
        composeErrorResponse(
          ['Old password is not correct! Please try typing it again'],
          401
        )
      );
  }

  await user.changePassword(newPassword);

  return res.status(200).send(successResponse());
});

export default authRouter;
