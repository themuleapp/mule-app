import TokenBlacklist from '../models/tokenBlacklist';

export default function (cron) {
  cron.schedule('* * 5 * * 7', () => {
    console.log(
      `Tokenlistjob running at ${new Date().getHours()} with timezon offset ${new Date().getTimezoneOffset()}`
    );

    TokenBlacklist.removeExpiredTokens();
  });
}
