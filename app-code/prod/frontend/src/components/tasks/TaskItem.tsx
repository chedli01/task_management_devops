import React, { useState, type FormEvent } from 'react';
import api from '../../services/api';
import type { Task } from '../../types/index';
import Card from '../common/Card';
import Input from '../common/Input';
import Button from '../common/Button';

interface TaskItemProps {
  task: Task;
  onUpdate: (task: Task) => void;
  onDelete: (taskId: string) => void;
}

const TaskItem: React.FC<TaskItemProps> = ({ task, onUpdate, onDelete }) => {
  const [isEditing, setIsEditing] = useState(false);
  const [title, setTitle] = useState(task.title);
  const [description, setDescription] = useState(task.description || '');
  const [loading, setLoading] = useState(false);

  const handleStatusChange = async (newStatus: Task['status']) => {
    setLoading(true);
    try {
      const response = await api.put<Task>(`/tasks/${task.id}`, { status: newStatus });
      onUpdate(response.data);
    } catch (err) {
      console.error('Failed to update task:', err);
    } finally {
      setLoading(false);
    }
  };

  const handleUpdate = async (e: FormEvent) => {
    e.preventDefault();
    setLoading(true);
    try {
      const response = await api.put<Task>(`/tasks/${task.id}`, {
        title: title.trim(),
        description: description.trim(),
      });
      onUpdate(response.data);
      setIsEditing(false);
    } catch (err) {
      console.error('Failed to update task:', err);
    } finally {
      setLoading(false);
    }
  };

  const handleDelete = async () => {
    if (!window.confirm('Are you sure you want to delete this task?')) return;

    setLoading(true);
    try {
      await api.delete(`/tasks/${task.id}`);
      onDelete(task.id);
    } catch (err) {
      console.error('Failed to delete task:', err);
    } finally {
      setLoading(false);
    }
  };

  const getPriorityColor = () => {
    switch (task.priority) {
      case 'high':
        return 'bg-red-500';
      case 'medium':
        return 'bg-yellow-500';
      case 'low':
        return 'bg-green-500';
      default:
        return 'bg-gray-500';
    }
  };

  const getStatusColor = () => {
    switch (task.status) {
      case 'completed':
        return 'bg-green-100 text-green-800';
      case 'in_progress':
        return 'bg-blue-100 text-blue-800';
      default:
        return 'bg-yellow-100 text-yellow-800';
    }
  };

  return (
    <Card className={loading ? 'opacity-60' : ''}>
      <div className="flex justify-between items-start mb-3">
        <span className={`${getPriorityColor()} text-white text-xs font-semibold px-3 py-1 rounded-full uppercase`}>
          {task.priority}
        </span>
        <span className={`${getStatusColor()} text-xs font-semibold px-3 py-1 rounded-full uppercase`}>
          {task.status.replace('_', ' ')}
        </span>
      </div>

      {isEditing ? (
        <form onSubmit={handleUpdate} className="space-y-3">
          <Input
            type="text"
            value={title}
            onChange={(e) => setTitle(e.target.value)}
            disabled={loading}
          />
          <textarea
            className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-primary-500"
            value={description}
            onChange={(e) => setDescription(e.target.value)}
            disabled={loading}
            rows={3}
          />
          <div className="flex gap-2">
            <Button type="submit" variant="success" disabled={loading}>
              Save
            </Button>
            <Button
              type="button"
              variant="secondary"
              onClick={() => setIsEditing(false)}
              disabled={loading}
            >
              Cancel
            </Button>
          </div>
        </form>
      ) : (
        <>
          <h4 className="text-lg font-semibold mb-2">{task.title}</h4>
          {task.description && (
            <p className="text-gray-600 text-sm mb-4">{task.description}</p>
          )}

          <div className="flex flex-wrap gap-2">
            {task.status !== 'completed' && (
              <Button
                variant="success"
                onClick={() => handleStatusChange('completed')}
                disabled={loading}
              >
                ✓ Complete
              </Button>
            )}
            {task.status === 'completed' && (
              <Button
                variant="secondary"
                onClick={() => handleStatusChange('pending')}
                disabled={loading}
              >
                ↻ Reopen
              </Button>
            )}
            <Button
              variant="secondary"
              onClick={() => setIsEditing(true)}
              disabled={loading}
            >
              ✎ Edit
            </Button>
            <Button variant="danger" onClick={handleDelete} disabled={loading}>
              🗑 Delete
            </Button>
          </div>

          <div className="mt-4 pt-4 border-t border-gray-200">
            <small className="text-gray-500">
              Created: {new Date(task.createdAt).toLocaleDateString()}
            </small>
          </div>
        </>
      )}
    </Card>
  );
};

export default TaskItem;