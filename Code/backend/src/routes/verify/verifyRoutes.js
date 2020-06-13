import { Router } from 'express';
import { v4 as uuidv4 } from 'uuid';
import User from '../../models//user';
import successResponse from '../../util/successResponse';
import composeErrorResponse from '../../util/composeErrorResponse';
import authMiddleware from '../../middleware/authMiddleware';
import { sendEmailVerificationEmail } from '../../util/emailer';

const verifyRoutes = Router();

verifyRoutes.get('/email/verified', authMiddleware, (req, res) => {
  const user = req.user;
  if (user.emailVerified) {
    res.status(200).send(successResponse('Email is verified'));
  } else {
    res.status(400).send(composeErrorResponse(['Email is not verified']));
  }
});

verifyRoutes.get('/email/resend', authMiddleware, (req, res) => {
  const user = req.user;
  if (user.emailVerified) {
    return res
      .status(400)
      .send(composeErrorResponse(['Email is already verified!']));
  }
  // Send verification email
  const emailVerificationCode = uuidv4();
  user.emailVerificationCode = emailVerificationCode;
  sendEmailVerificationEmail(user.email, req, emailVerificationCode);

  res.status(200).send(successResponse('Verification code resent'));
});

verifyRoutes.get('/email/:code', async (req, res) => {
  const { code } = req.params;
  if (!(await User.verifyEmail(code))) {
    return res
      .status(400)
      .send(composeErrorResponse(['Error verifying your email!']));
  }
  return res.status(200).send(successResponse('Email verified successfully!'));
});

export default verifyRoutes;
