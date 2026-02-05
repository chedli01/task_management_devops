import app from './app';

const startServer = async (): Promise<void> => {
  try {
    app.listen(3000, () => {
      console.log(`Server running on port 3000`);
      console.log(`Environment: dev`);
    });
  } catch (error) {
    console.error('Unable to start server:', error);
    process.exit(1);
  }
};

startServer();