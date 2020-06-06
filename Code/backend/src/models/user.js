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

userSchema.methods.createResetId = async function () {
  const id = uuidV4();
  this.resetId = id;
  this.resetIdExpiration = Date.now() + 86400000;
  await this.save();
  return id;
};

userSchema.methods.hasResetToken = function () {
  return this.resetId;
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

userSchema.statics.resetPasswordWithId = async function (id, password) {
  const user = await this.findOne({ resetId: id });
  if (!user) {
    return null;
  }

  if (user.resetIdExpiration < Date.now()) {
    // Remove the reset id before
    user.resetId = null;
    user.resetIdExpiration = null;
    await user.save();
    return false;
  }
  // Remove the reset id cause now it's used up
  user.resetId = null;
  user.resetIdExpiration = null;
  user.password = password;
  await user.save();
  return true;
};

export default mongoose.model('User', userSchema);
