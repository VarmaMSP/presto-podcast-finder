const path = require('path');

const PROJECT_PATH = path.join(__dirname, '..')

module.exports = {
  entry: [
    path.join(PROJECT_PATH, 'index.jsx')
  ],
  output: {
    path: path.join(PROJECT_PATH, 'dist'),
    filename: 'bundle.js'
  },
  resolve: {
    modules: [
      path.join(PROJECT_PATH, 'node_modules'),
      path.join(PROJECT_PATH, 'src'),
      path.join(PROJECT_PATH, 'views')
    ],
    extensions: ['.js', '.jsx']
  },
  module: {
    loaders: [
      {
        test: /\.jsx$/,
        loader: 'babel-loader',
        query: {
          presets: ['react', 'es2015', 'stage-0']
        },
        exclude: /node_modules/
      }
    ]
  }
};
