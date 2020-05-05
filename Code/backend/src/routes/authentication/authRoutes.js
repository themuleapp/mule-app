import { Router } from 'express';
import User from '../../models/user';
import asyncErrorCatcher from '../../util/asyncErrorCatcher';
import composeErrorResponse from '../../util/composeErrorResponse';
import {
  validateSignupDate,
  validateLoginData,
  validateRequestResetPasswordData,
  validateResetPasswordData,
} from './authValidators';
import { createTransporter, sendResetId } from '../../util/emailer';

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
      return res.send(
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
      console.log('here');

      // Login a registered user
      const { email, password } = req.body;
      console.log(email);
      const user = await User.findByCredentials(email, password); // TODO this throws error when credentials not good
      console.log('Found');
      if (!user) {
        return res
          .status(401)
          .send(
            composeErrorResponse(
              ['Login failed! Check authentication credentials'],
              401
            )
          );
      }
      const token = await user.generateAuthToken();
      res.send({ user, token });
    } catch (error) {
      // TODO we shouldn't be here? Empty error something is being thrown
      console.log(`Shit ${error}`);
      console.log(error);
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
  console.log(req.body.email);
  console.log(user);
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
