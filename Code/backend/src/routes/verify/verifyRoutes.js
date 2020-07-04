import { Router } from 'express';
import { v4 as uuidv4 } from 'uuid';
import User from '../../models//user';
import successResponse from '../../util/successResponse';
import composeErrorResponse from '../../util/composeErrorResponse';
import authMiddleware from '../../middleware/authMiddleware';
import { sendEmailVerificationEmail } from '../../util/emailer';

const verifyRoutes = Router();

/**
 * @swagger
 * /api/verify/email/verified:
 *    get:
 *      summary: Checks whether users email is verified
 *      tags:
 *        - email verification
 *      consumes:
 *        - application/json
 *      parameters:
 *        - in: header
 *          name: Authorization
 *          type: JWT Bearer
 *      responses:
 *        200:
 *          description: Success message email is verified
 *        400:
 *          description: Fail with message that email is not verified
 */
verifyRoutes.get('/email/verified', authMiddleware, (req, res) => {
  const user = req.user;
  if (user.emailVerified) {
    res.status(200).send(successResponse('Email is verified'));
  } else {
    res.status(400).send(composeErrorResponse(['Email is not verified']));
  }
});

/**
 * @swagger
 * /api/verify/email/resend:
 *    get:
 *      summary: Resends an email verification link to the user
 *      tags:
 *        - email verification
 *      consumes:
 *        - application/json
 *      parameters:
 *        - in: header
 *          name: Authorization
 *          type: JWT Bearer
 *      responses:
 *        200:
 *          description: Success message that verification link has been resent
 *        400:
 *          description: Fail with a message that email has already been verified
 */
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

/**
 * @swagger
 * /api/verify/email/<VERIFICATION_CODE>:
 *    get:
 *      summary: Checks the given verification code and verifies a user if it's the correct one
 *      tags:
 *        - email verification
 *      consumes:
 *        - application/json
 *      responses:
 *        200:
 *          description: Success message that Email was verified successfully
 *        400:
 *          description: Fail with a message email verification failed for some reason
 */
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
