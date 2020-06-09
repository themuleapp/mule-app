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

userSchema.methods.generateAuthToken = async function () {
  // Generate an auth token for the user
  const user = this;
  const token = jwt.sign({ _id: user._id }, process.env.JWT_KEY, {
    expiresIn: process.env.JWT_VALIDATION,
  });
  // user.tokens = user.tokens.concat({ token });
  await user.save();
  return token;
};

userSchema.statics.updateData = function (updateData, user) {
  return this.update({ _id: user._id }, updateData);
};

userSchema.statics.findByCredentials = async function (email, password) {
  // Search for a user by email and password.
  const user = await this.findOne({ email });
  // const user = await User/.findOne({ email });
  if (!user) {
    // throw new Error({ error: 'Invalid login credentials' });
    return null;
  }
  const isPasswordMatch = await bcrypt.compare(password, user.password);
  if (!isPasswordMatch) {
    return null;
    // throw new Error({ error: 'Invalid login credentials' });
  }
  return user;
};

userSchema.statics.existsByEmail = async function (email) {
  return await this.exists({ email });
};

userSchema.statics.getByEmail = async function (email) {
  return await this.findOne({ email });
};

userSchema.methods.createResetId = async function () {
  const id = uuidV4();
  this.resetId = id;

  this.resetIdExpiration =
    Date.now() + parseInt(process.env.RESET_TOKEN_VALIDITY, 10);
  await this.save();
  return id;
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

export default mongoose.model('User', userSchema);
