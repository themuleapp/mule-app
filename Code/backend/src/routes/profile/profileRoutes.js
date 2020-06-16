import { Router } from 'express';
import { validateUpdateData } from './profileValidators';
import User from '../../models/user';
import composeErrorResponse from '../../util/composeErrorResponse';
import composeSuccessResponse from '../../util/successResponse';

const profileRouter = Router();

/**
 * @swagger
 * /api/profile:
 *    get:
 *      summary: Gets logged in user profile information
 *      tags:
 *        - profile
 *      consumes:
 *        - application/json
 *      parameters:
 *        - in: header
 *          name: Authorization
 *          type: JWT Bearer
 *      responses:
 *        200:
 *          description: the logged in user profile information
 */
profileRouter.get('/', (req, res) => {
  const { firstName, lastName, email, phoneNumber, emailVerified } = req.user;
  res.status.status(200).send({
    firstName,
    lastName,
    email,
    phoneNumber,
    emailVerified,
  });
});

/**
 * @swagger
 * /api/profile/update:
 *    post:
 *      summary: Updates properties on user object
 *      description: Updates the properties that are given within the request
 *      tags:
 *        - profile
 *      consumes:
 *        - application/json
 *      parameters:
 *        - in: header
 *          name: Authorization
 *          type: JWT Bearer
 *        - in: body
 *          name: profile info to change
 *          description:
 *          schema:
 *            type: object
 *            properties:
 *              firstName:
 *                type: string
 *                required: false
 *              lastName:
 *                required: false
 *                type: string
 *              email:
 *                required: false
 *                type: string
 *              phoneNumber:
 *                required: false
 *                type: string
 *      responses:
 *        200:
 *          description: Success response
 *        400:
 *          description: fail with error message(s)
 */
profileRouter.post('/update', async (req, res) => {
  const validation = validateUpdateData(req.body);
  if (validation) {
    return res.send(composeErrorResponse(validation, 400));
  }

  await User.updateData(req.body, req.user);
  return res.send(composeSuccessResponse('User info updated successfully'));
});

export default profileRouter;
