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

  // TODO think if this is really needed
  // tokens: [{
  //     token: {
  //         type: String,
  //         required: true
  //     }
  // }]
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
  const token = jwt.sign({ _id: user._id }, process.env.JWT_KEY);
  // user.tokens = user.tokens.concat({ token });
  await user.save();
  return token;
};

userSchema.methods.createResetId = async function (email) {
  const id = uuidV4();
  this.resetId = id;
  this.resetIdExpiration = Date.now() + 86400000;
  await this.save();
  return id;
};

userSchema.statics.findByCredentials = async function (email, password) {
  // Search for a user by email and password.
  const user = await this.findOne({ email });
  // const user = await User/.findOne({ email });
  if (!user) {
    throw new Error({ error: 'Invalid login credentials' });
  }
  const isPasswordMatch = await bcrypt.compare(password, user.password);
  if (!isPasswordMatch) {
    throw new Error({ error: 'Invalid login credentials' });
  }
  return user;
};

userSchema.statics.existsByEmail = async function (email) {
  return await this.exists({ email });
};

userSchema.statics.getByEmail = async function (email) {
  return await this.findOne({ email });
};

export default mongoose.model('User', userSchema);
