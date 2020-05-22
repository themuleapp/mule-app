import Joi from '@hapi/joi';

export function validateUpdateData(updateData) {
  if (Object.keys(updateData).length === 0) {
    return ['Data is empty'];
  }
  const validation = Joi.object({
    firstName: Joi.string(),
    lastName: Joi.string(),
    email: Joi.string().email(),
    phoneNumber: Joi.string().max(12),
  }).validate(updateData, { abortEarly: false });

  if (validation?.error?.details) {
    return validation.error.details.map(x => x.message);
  }
  return null;
}
