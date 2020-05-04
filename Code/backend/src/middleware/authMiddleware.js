import jwt from 'jsonwebtoken';
import User from '../models/user';

export default async (req, res, next) => {
  // Get token
  const token = req.header('Authorization').replace('Bearer ', '');
  console.log(`token: ${token}`);

  try {
    // verify valid
    const data = jwt.verify(token, process.env.JWT_KEY);
    console.log('Here');
    console.log(data);
    const user = await User.findOne({ _id: data._id });
    if (!user) {
      // Weird case here because where's the user since he has a token???
      // throw new Error();
      // TODO
      res.status(401).send({ error: 'No user found' });
    }

    // Set the user and token on the request object to be further used in the routes
    req.user = user;
    req.token = token;
    next();
  } catch (error) {
    res.status(401).send({ error: 'Error caught' });
  }
};
