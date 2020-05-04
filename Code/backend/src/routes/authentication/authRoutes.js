import { Router } from 'express';
import User from '../../models/user';
import asyncErrorCatcher from '../../util/asyncErrorCatcher';
import composeErrorResponse from '../../util/composeErrorResponse';
import { validateSignupDate, validateLoginData } from './authValidators';

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
    if (await User.existsByEmail('ji@darwish.com')) {
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
      const user = await User.findByCredentials(email, password);
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
      console.log(`Shit ${error}`);
      res.status(400).send(error);
    }
  })
);
export default authRouter;
