module.exports = {
  plugins: {
    'postcss-import': {},
    'postcss-url': {
      url: 'copy',
    },
    tailwindcss: {},
    autoprefixer: {},
    'postcss-nested': {},
    ...(process.env.NODE_ENV === 'production'
      ? { cssnano: { preset: 'default' } }
      : {}),
  },
};
