import { Request, Response, NextFunction } from 'express';
import { ValidationError } from 'sequelize';

export const errorHandler = (
  err: any,
  req: Request,
  res: Response,
  next: NextFunction
): void => {
  console.error('Error:', err);

  if (err instanceof ValidationError) {
    res.status(400).json({
      error: 'Validation error',
      details: err.errors.map((e) => e.message),
    });
    return;
  }

  if (err.name === 'SequelizeUniqueConstraintError') {
    res.status(409).json({
      error: 'Resource already exists',
      details: err.errors?.map((e: any) => e.message) || [],
    });
    return;
  }

  res.status(err.status || 500).json({
    error: err.message || 'Internal server error',
  });
};