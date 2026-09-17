import { create } from 'zustand';
import { User } from '@/lib/types';

interface AuthState {
  user: User | null;
  setUser: (user: User | null) => void;
  logout: () => void;
}

export const useAuthStore = create<AuthState>((set) => ({
  // Mocking a Super Admin for now so we can see everything
  user: {
    id: '1',
    name: 'Admin User',
    email: 'admin@helpaprisoner.org',
    role: 'SUPER_ADMIN',
    status: 'ACTIVE',
  },
  setUser: (user) => set({ user }),
  logout: () => set({ user: null }),
}));