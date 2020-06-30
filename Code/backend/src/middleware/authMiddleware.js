import jwt from 'jsonwebtoken';
import User from '../models/user';
import TokenBlacklist from '../models/tokenBlacklist';
import composeErrorResponse from '../util/composeErrorResponse';

export default async (req, res, next) => {
  if (!req.header('Authorization')) {
    return res.status(401).send(composeErrorResponse(['Not logged in'], 400));
  }
  // Get token
  const token = req.header('Authorization').replace('Bearer ', '');

  try {
    // verify valid
    if (await TokenBlacklist.tokenIsBlacklisted(token)) {
      throw Error('Blacklisted token');
    }
    const data = jwt.verify(token, process.env.JWT_KEY);
    const user = await User.findOne({ _id: data._id });
    if (!user) {
      // Weird case here because where's the user since he has a token???
      // throw new Error();
      // TODO
      res.status(401).send(composeErrorResponse(['No user found'], 400));
    }

    // Set the user and token on the request object to be further used in the routes
    req.user = user;
    req.token = token;
    next();
  } catch (error) {
    console.error(error);
    res.status(401).send({ status: 401, error: 'Token invalid' });
  }
};
