import nodemailer from 'nodemailer';

export function createTransporter() {
  return nodemailer.createTransport({
    service: 'gmail',
    secure: false,
    port: 25,
    tls: {
      rejectUnauthorized: false,
    },
    auth: {
      user: process.env.SENDER_EMAIL,
      pass: process.env.SENDER_PASS,
    },
  });
}

export function sendResetId(transporter, toEmail, id) {
  return transporter.sendMail(
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
