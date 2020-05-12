export default fn => (...args) =>
  fn(...args).catch(err => console.error(`An error occured ${err}`));
