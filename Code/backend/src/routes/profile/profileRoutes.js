import { Router } from 'express';
import { validateUpdateData } from './profileValidators';
import User from '../../models/user';
import composeErrorResponse from '../../util/composeErrorResponse';
import composeSuccessResponse from '../../util/successResponse';

const profileRouter = Router();

profileRouter.get('/', (req, res) => {
  const { firstName, lastName, email, phoneNumber } = req.user;
  res.send({
    firstName,
    lastName,
    email,
    phoneNumber,
  });
});

profileRouter.post('/update', async (req, res) => {
  const validation = validateUpdateData(req.body);
  if (validation) {
    return res.send(composeErrorResponse(validation, 400));
  }

  await User.updateData(req.body, req.user);
  return res.send(composeSuccessResponse('User info updated successfully'));
});

export default profileRouter;
