import jwt from 'jsonwebtoken';
import mongoose from 'mongoose';

const tokenBlacklistSchema = mongoose.Schema({
  token: {
    type: String,
    required: true,
    trim: true,
  },
});

tokenBlacklistSchema.statics.tokenIsBlacklisted = async function (token) {
  const exists = await this.exists({ token });
  return exists;
};

tokenBlacklistSchema.statics.isTokenValid = function (token) {
  try {
    jwt.verify(token, process.env.JWT_KEY);
    return true;
  } catch (error) {
    console.error(error);
    return false;
  }
};

tokenBlacklistSchema.statics.removeExpiredTokens = async function () {
  const tokens = await this.find();
  await tokens.forEach(async tokenDoc => {
    // Try verifying a token which will fail if it's expired => it's removed
    try {
      jwt.verify(tokenDoc.token, process.env.JWT_KEY);
    } catch (err) {
      await tokenDoc.remove();
    }
  });
};

export default mongoose.model('tokenBlacklist', tokenBlacklistSchema);
