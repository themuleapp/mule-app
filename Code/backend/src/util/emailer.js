import nodemailer from 'nodemailer';

function getTransport() {
  return nodemailer.createTransport({
    host: 'smtp.gmail.com',
    port: 465,
    auth: {
      type: 'OAuth2',
      user: process.env.SENDER_EMAIL,
      clientId: process.env.EMAIL_CLIENT_ID,
      clientSecret: process.env.EMAIL_CLIENT_SECRET,
      refreshToken: process.env.EMAIL_CLIENT_REFRESH_TOKEN,
    },
  });
}

export function sendResetId(toEmail, id) {
  return getTransport().sendMail(
    {
      from: `"${process.env.SENDER_EMAIL_NAME}" <${process.env.SENDER_EMAIL}`,
      to: toEmail,
      subject: 'WhisperingMule reset password',
      text: `Your reset id is ${id}`,
    },
    (err, info) => {
      if (err) {
        console.error(err);
      } else {
        console.log(info);
      }
    }
  );
}

export function sendEmailVerificationEmail(toEmail, req, code) {
  const { protocol, hostname } = req;
  const link = `${protocol}://${hostname}/api/verify/email/${code}`;
  console.log(link);
  return getTransport().sendMail(
    {
      from: `"${process.env.SENDER_EMAIL_NAME}" <${process.env.SENDER_EMAIL}>`,
      to: toEmail,
      subject: 'WhisperingMule Verify your email',
      text: `Click on this link to verify your email ${link}`,
    },
    (err, info) => {
      if (err) {
        console.error(err);
      } else {
        console.log(info);
      }
    }
  );
}
