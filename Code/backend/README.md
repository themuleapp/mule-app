# The Backend to the whisperingMule Mobile App

This is a guide for running the backend localy if you want to start the development process.

1. Navigate into <PROJECT_ROOT>/Code/backend
2. Run

```
  npm install
```

This will install all the dependencies you need to run the app

3. Create a file callend `.env` and copy the contents of `.testenv` to it
4. Now fill in values for all the placeholders:

   - `PORT`: Which port you want to run it on (e.g. 3000)
   - `SALT_ROUNDS`: For hashing the password (suggested: 10)
   - `JWT_KEY`: Key used for creating JWTs for authenticating users. You can generate your own. Run the following piece of code to generate yours:

   ```
   require('crypto').randomBytes(48, function(err, buffer) { var token = buffer.toString('hex'); console.log(token); });
   ```

   - `JWT_VALIDATION`: For how long the JWT is valid, value is a [zeit/ms](https://github.com/zeit/ms) (e.g. 30d)
   - `RESET_TOKEN_VALIDITY` How long the reset password token (OTP) is valid for, value is in milliseconds (suggested 15 min = 900000 ms).
   - For the email values you can use your own development email, beaware that for it to work you have to [allow less secure apps](https://hotter.io/docs/email-accounts/secure-app-gmail/) since the backend will be running on your machine (http) google sees it as a less secure app.
   - `MONGODB_URI`: where your local mongoDb is residing.

5) Once all values set, in your terminal navigate to \*/backend and run

```
npm run dev
```

## If you for some reason want to run the backend directly against the production database

Contact [Ji](https://github.com/JiDarwish) to get your credentials to the database (`MONGODB_URI`) and the `JWT_KEY` on the backend
