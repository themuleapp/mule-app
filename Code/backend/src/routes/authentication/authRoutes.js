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
} from './authValidators';
import { createTransporter, sendResetId } from '../../util/emailer';
import authMiddleware from '../../middleware/authMiddleware';
import tokenBlacklist from '../../models/tokenBlacklist';

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
    res.status(201).send({ token });
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

// Using auth middleware here
authRouter.delete('/logout', authMiddleware, async (req, res) => {
  const token = req.token;
  const blackListedToken = new TokenBlacklist({ token });
  await blackListedToken.save();
  res.status(205).send();
});

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
  const id = await user.createResetId();

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

  const id = await user.createResetId();

  sendResetId(createTransporter(), user.email, id);

  return res.status(200).send({ id });
});

authRouter.post('/reset', async (req, res) => {
  const validation = validateResetPasswordData(req.body);
  if (validation) {
    return res.status(400).send(composeErrorResponse(validation, 400));
  }
  // find user that has the reset id (since it's unique uuid)
  const user = await User.resetPasswordWithId(req.body.id, req.body.password);

  // If this returns false then either there's no such id or id is expired
  if (!user) {
    res
      .status(401)
      .send(
        composeErrorResponse(
          ['Reset id invalid! Please generate a new one'],
          401
        )
      );
  }

  return res.status(200).send();
});

export default authRouter;
