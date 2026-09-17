import { 
  Megaphone, 
  FolderKanban, 
  Users, 
  Building2, 
  HeartHandshake,
  AlertCircle,
  CheckCircle2,
  Clock,
  FileText
} from 'lucide-react';
import { cn } from '@/lib/utils';

// Mock data for now - will be replaced by API
const overviewStats = [
  { label: 'Donations Raised', value: '₦12.4M', icon: HeartHandshake, trend: '+12%' },
  { label: 'Active Campaigns', value: '18', icon: Megaphone, trend: '+3' },
  { label: 'Active Projects', value: '12', icon: FolderKanban, trend: '-1' },
  { label: 'People Supported', value: '1,250', icon: Users, trend: '+45' },
];

const pendingActions = [
  { id: 1, type: 'Campaign Review', count: 12, message: 'Campaigns awaiting review', priority: 'high' },
  { id: 2, type: 'Organization Verification', count: 4, message: 'Organizations awaiting verification', priority: 'high' },
  { id: 3, type: 'Impact Report', count: 7, message: 'Impact reports awaiting review', priority: 'medium' },
  { id: 4, type: 'Volunteer Application', count: 3, message: 'Volunteer applications', priority: 'low' },
  { id: 5, type: 'Payment Issue', count: 2, message: 'Payment issues detected', priority: 'critical' },
];

const recentActivity = [
  { id: 1, action: 'Campaign approved', details: 'Digital Skills Training', time: '10 mins ago', icon: CheckCircle2, color: 'text-green-500' },
  { id: 2, action: 'Donation received', details: '₦50,000 for Library Project', time: '25 mins ago', icon: HeartHandshake, color: 'text-blue-500' },
  { id: 3, action: 'Report submitted', details: 'Q3 Impact Report - Golden Heart', time: '1 hour ago', icon: FileText, color: 'text-purple-500' },
  { id: 4, action: 'Organization verified', details: 'Dominion City Prisons Ministry', time: '3 hours ago', icon: Building2, color: 'text-green-500' },
];

export default function DashboardHome() {
  return (
    <div className="space-y-6">
      {/* Welcome Header */}
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Good morning, Admin</h1>
        <p className="text-gray-500 mt-1">Here is what is happening with Help A Prisoner today.</p>
      </div>

      {/* Top-Level Metrics (Section 6.3) */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        {overviewStats.map((stat) => (
          <div key={stat.label} className="bg-white p-5 rounded-xl border border-gray-100 shadow-sm flex items-start justify-between">
            <div>
              <p className="text-sm text-gray-500 font-medium">{stat.label}</p>
              <p className="text-2xl font-bold text-[#0D1B2A] mt-2">{stat.value}</p>
            </div>
            <div className="p-2 bg-gray-50 rounded-lg">
              <stat.icon size={20} className="text-[#D4AF37]" />
            </div>
          </div>
        ))}
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Pending Actions (Section 6.3) */}
        <div className="lg:col-span-2 bg-white rounded-xl border border-gray-100 shadow-sm p-6">
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-lg font-bold text-[#0D1B2A]">Pending Actions</h2>
            <span className="text-xs font-semibold bg-red-100 text-red-600 px-2 py-1 rounded-full">5 Require Attention</span>
          </div>
          <div className="space-y-3">
            {pendingActions.map((action) => (
              <div key={action.id} className="flex items-center justify-between p-3 bg-gray-50 rounded-lg hover:bg-gray-100 transition-colors cursor-pointer">
                <div className="flex items-center gap-3">
                  <div className={cn(
                    "w-2 h-2 rounded-full",
                    action.priority === 'critical' ? 'bg-red-500' :
                    action.priority === 'high' ? 'bg-orange-500' :
                    action.priority === 'medium' ? 'bg-yellow-500' : 'bg-blue-500'
                  )} />
                  <div>
                    <p className="text-sm font-semibold text-gray-800">{action.message}</p>
                    <p className="text-xs text-gray-500">{action.type}</p>
                  </div>
                </div>
                <div className="flex items-center gap-2">
                  <span className="text-lg font-bold text-[#0D1B2A]">{action.count}</span>
                  <AlertCircle size={16} className="text-gray-400" />
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* Recent Activity */}
        <div className="bg-white rounded-xl border border-gray-100 shadow-sm p-6">
          <h2 className="text-lg font-bold text-[#0D1B2A] mb-4">Recent Activity</h2>
          <div className="space-y-4">
            {recentActivity.map((activity) => (
              <div key={activity.id} className="flex gap-3">
                <div className={cn("mt-0.5", activity.color)}>
                  <activity.icon size={18} />
                </div>
                <div>
                  <p className="text-sm font-semibold text-gray-800">{activity.action}</p>
                  <p className="text-xs text-gray-500">{activity.details}</p>
                  <p className="text-xs text-gray-400 mt-1 flex items-center gap-1">
                    <Clock size={12} /> {activity.time}
                  </p>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
}