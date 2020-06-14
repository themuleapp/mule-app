import mongoose from 'mongoose';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import { v4 as uuidV4 } from 'uuid';

const userSchema = mongoose.Schema({
  firstName: {
    type: String,
    required: true,
    trim: true,
  },
  lastName: {
    type: String,
    required: true,
    trim: true,
  },
  email: {
    type: String,
    required: true,
    unique: true,
    lowercase: true,
  },
  emailVerificationCode: {
    type: String,
    default: null,
  },
  emailVerified: {
    type: Boolean,
    default: false,
  },
  phoneNumber: {
    type: String,
    required: false,
    max: 12,
  },
  password: {
    type: String,
    required: true,
    // minLength: 7,
  },

  resetId: {
    type: String,
    required: false,
    default: null,
  },
  resetIdExpiration: {
    type: Date,
    required: false,
    default: null,
  },
  dateIssued: {
    type: Date,
    required: false,
    default: Date.now,
  },
});

userSchema.pre('save', async function (next) {
  // Hash the password before saving the user model
  const user = this;
  if (user.isModified('password')) {
    user.password = await bcrypt.hash(
      user.password,
      parseInt(process.env.SALT_ROUNDS)
    );
  }
  next();
});

userSchema.statics.updateData = function (updateData, user) {
  return this.update({ _id: user._id }, updateData);
};

userSchema.statics.findByCredentials = async function (email, password) {
  // Search for a user by email and password.
  const user = await this.findOne({ email });
  if (!user) {
    return null;
  }
  const isPasswordMatch = await bcrypt.compare(password, user.password);
  if (!isPasswordMatch) {
    return null;
  }
  return user;
};

userSchema.statics.existsByEmail = async function (email) {
  return await this.exists({ email });
};

userSchema.statics.getByEmail = async function (email) {
  return await this.findOne({ email });
};

userSchema.statics.verifyEmail = async function (emailVerificationCode) {
  const user = await this.findOne({ emailVerificationCode });
  if (!user) {
    return false;
  }
  user.emailVerified = true;
  user.emailVerificationCode = null;
  await user.save();
  return true;
};

userSchema.methods.generateAuthToken = function () {
  // Generate an auth token for the user
  const user = this;
  const token = jwt.sign({ _id: user._id }, process.env.JWT_KEY, {
    expiresIn: process.env.JWT_VALIDATION,
  });
  return token;
};

userSchema.methods.verifyPassword = async function (oldPassword) {
  const isPasswordMatch = await bcrypt.compare(oldPassword, this.password);
  if (!isPasswordMatch) {
    return false;
  }
  return true;
};

userSchema.methods.changePassword = async function (newPassword) {
  this.password = newPassword;
  await this.save();
};

userSchema.methods.createResetToken = async function () {
  this.resetId = Math.floor(100000 + Math.random() * 900000);

  this.resetIdExpiration =
    Date.now() + parseInt(process.env.RESET_TOKEN_VALIDITY, 10);
  await this.save();
  return this.resetId;
};

userSchema.methods.hasResetToken = function () {
  return this.resetId;
};

userSchema.methods.isResetTokenExpired = async function () {
  console.log(
    `token exp: ${this.resetIdExpiration.getTime()} now: ${Date.now()}`
  );
  if (this.resetIdExpiration.getTime() < Date.now()) {
    console.log('Here what');
    // Remove the reset id before
    this.resetId = null;
    this.resetIdExpiration = null;
    await this.save();
    return true;
  }
  return false;
};

userSchema.methods.resetPassword = async function (password) {
  // Remove the reset id cause now it's used up
  this.resetId = null;
  this.resetIdExpiration = null;
  this.password = password;
  await this.save();
  return true;
};

userSchema.methods.deleteAccount = async function () {
  await this.remove();
};
export default mongoose.model('User', userSchema);
