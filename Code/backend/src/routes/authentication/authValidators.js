import Joi from '@hapi/joi';

export function validateSignupDate(signUpData) {
  const validation = Joi.object({
    firstName: Joi.string().required(),
    lastName: Joi.string().required(),
    email: Joi.string().email().required(),
    phoneNumber: Joi.string().max(12).required(), // TODO is 12 really the longest?
    password: Joi.string().required(),
  }).validate(signUpData, { abortEarly: false });

  if (validation?.error?.details) {
    return validation.error.details.map(x => x.message);
  }
  return null;
}

export function validateLoginData(loginData) {
  const validation = Joi.object({
    email: Joi.string().email().required(),
    password: Joi.string().required(),
  }).validate(loginData, { abortEarly: false });

  if (validation?.error?.details) {
    return validation.error.details.map(x => x.message);
  }
  return null;
}
