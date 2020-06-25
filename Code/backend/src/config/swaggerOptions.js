// Extended: https://swagger.io/specification/#infoObject
export default {
  swaggerDefinition: {
    info: {
      version: '1.0.0',
      title: 'Mule RESTApi',
      description: 'The backend used by the WhisperingMule Mobile Application',
      produces: ['application/json', 'application/xml'],
      schemes: ['http', 'https'],
      contact: {
        name: 'Ji Darwish',
        email: 'ji.darwish98@gmail.com',
      },
      servers: [
        'http://localhost:5000',
        'https://whisperingmule.herokuapp.com/',
      ],
    },
  },
  apis: ['src/index.js', './src/routes/**/*.js'],
  // Define req bodies and such in here
  // components: {
  //   schemas: {
  //     user: {
  //       type: 'object',
  //       properties: {
  //         firstName: { type: 'string' },
  //         lastName: { type: 'string' },
  //         email: { type: 'string' },
  //         phoneNumber: { type: 'string' },
  //         password: { type: 'string' },
  //       },
  //     },
  //   },
  // },
};