'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { 
  LayoutDashboard, Megaphone, FolderKanban, GraduationCap, Users, 
  HeartHandshake, Building2, MapPin, BarChart3, Bell, FileText, 
  Settings, ShieldCheck, X, Handshake
} from 'lucide-react';
import { cn } from '@/lib/utils';
import { useAuthStore } from '@/store/useAuthStore';
import { useUIStore } from '@/store/useUIStore';

const navigation = [
  { name: 'Dashboard', href: '/dashboard', icon: LayoutDashboard, category: 'OPERATIONS' },
  { name: 'Campaigns', href: '/dashboard/campaigns', icon: Megaphone, category: 'OPERATIONS' },
  { name: 'Projects', href: '/dashboard/projects', icon: FolderKanban, category: 'OPERATIONS' },
  { name: 'Training', href: '/dashboard/training', icon: GraduationCap, category: 'OPERATIONS' },
  { name: 'Volunteers', href: '/dashboard/volunteers', icon: Users, category: 'OPERATIONS' },
  { name: 'Donations', href: '/dashboard/donations', icon: HeartHandshake, category: 'FINANCE' },
  { name: 'Reports', href: '/dashboard/reports', icon: BarChart3, category: 'FINANCE' },
  { name: 'Organizations', href: '/dashboard/organizations', icon: Building2, category: 'ORGANIZATION' },
  { name: 'Facilities', href: '/dashboard/facilities', icon: MapPin, category: 'ORGANIZATION' },
  { name: 'Impact Reports', href: '/dashboard/impact', icon: FileText, category: 'IMPACT' },
  { name: 'Notifications', href: '/dashboard/notifications', icon: Bell, category: 'CONTROL' },
  { name: 'Audit Logs', href: '/dashboard/audit-logs', icon: ShieldCheck, category: 'CONTROL' },
  { name: 'Settings', href: '/dashboard/settings', icon: Settings, category: 'CONTROL' },
];

export default function Sidebar() {
  const pathname = usePathname();
  const user = useAuthStore((state) => state.user);
  const { isSidebarOpen, closeSidebar } = useUIStore();

  const groupedNav = navigation.reduce((acc, item) => {
    if (!acc[item.category]) acc[item.category] = [];
    acc[item.category].push(item);
    return acc;
  }, {} as Record<string, typeof navigation>);

  return (
    <>
      {/* Mobile Overlay */}
      {isSidebarOpen && (
        <div 
          className="fixed inset-0 bg-black/50 z-40 lg:hidden"
          onClick={closeSidebar}
        />
      )}

      {/* Sidebar */}
      <aside className={cn(
        "fixed lg:static inset-y-0 left-0 z-50 w-64 bg-[#0D1B2A] text-white flex flex-col h-screen transition-transform duration-300 ease-in-out shrink-0",
        isSidebarOpen ? "translate-x-0" : "-translate-x-full lg:translate-x-0"
      )}>
        {/* Logo Area */}
        <div className="p-6 border-b border-gray-800 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="h-10 w-10 rounded-full bg-[#D4AF37] flex items-center justify-center">
              <Handshake size={22} className="text-[#0D1B2A]" />
            </div>
            <div>
              <h1 className="text-base font-bold font-serif tracking-wide text-[#D4AF37] leading-tight">
                Help A Prisoner
              </h1>
              <p className="text-xs text-gray-400 mt-0.5">Admin Portal</p>
            </div>
          </div>
          {/* Mobile Close Button */}
          <button 
            onClick={closeSidebar}
            className="lg:hidden text-gray-400 hover:text-white"
          >
            <X size={20} />
          </button>
        </div>

        {/* User Profile Summary */}
        <div className="p-4 border-b border-gray-800 bg-[#1B2A3A]">
          <div className="flex items-center gap-3">
            <div className="w-8 h-8 rounded-full bg-[#D4AF37] flex items-center justify-center text-[#0D1B2A] font-bold text-sm">
              {user?.name?.charAt(0) || 'A'}
            </div>
            <div className="overflow-hidden">
              <p className="text-sm font-semibold truncate">{user?.name}</p>
              <p className="text-xs text-gray-400 truncate">{user?.role.replace('_', ' ')}</p>
            </div>
          </div>
        </div>

        {/* Navigation */}
        <nav className="flex-1 p-4 space-y-6 overflow-y-auto">
          {Object.entries(groupedNav).map(([category, items]) => (
            <div key={category}>
              <h3 className="text-xs font-semibold text-gray-500 uppercase tracking-wider mb-2 px-3">
                {category}
              </h3>
              <ul className="space-y-1">
                {items.map((item) => {
                  const isActive = pathname === item.href;
                  return (
                    <li key={item.name}>
                      <Link
                        href={item.href}
                        onClick={closeSidebar}
                        className={cn(
                          "flex items-center gap-3 px-3 py-2 rounded-md text-sm transition-colors",
                          isActive 
                            ? "bg-[#D4AF37] text-[#0D1B2A] font-semibold" 
                            : "text-gray-300 hover:bg-[#1B2A3A] hover:text-white"
                        )}
                      >
                        <item.icon size={18} />
                        {item.name}
                      </Link>
                    </li>
                  );
                })}
              </ul>
            </div>
          ))}
        </nav>
      </aside>
    </>
  );
}