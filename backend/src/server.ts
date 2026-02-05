import app from './app';
import { connectDatabase } from './config/databse';

const startServer = async (): Promise<void> => {
  try {
    await connectDatabase();

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