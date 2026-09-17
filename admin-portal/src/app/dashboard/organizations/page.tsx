'use client';

import { useState } from 'react';
import Link from 'next/link';
import { 
  Plus, Search, MoreVertical, Eye, AlertCircle, Users, ShieldCheck, ShieldAlert, Clock
} from 'lucide-react';
import { cn } from '@/lib/utils';
import { mockOrganizations, VerificationStatus } from '@/lib/mockData';

const statusFilters: { label: string; value: VerificationStatus | 'ALL' }[] = [
  { label: 'All', value: 'ALL' },
  { label: 'Verified', value: 'VERIFIED' },
  { label: 'Pending Verification', value: 'PENDING_VERIFICATION' },
  { label: 'More Info Requested', value: 'MORE_INFO_REQUESTED' },
  { label: 'Rejected', value: 'REJECTED' },
];

const getStatusStyle = (status: VerificationStatus) => {
  switch (status) {
    case 'VERIFIED': return 'bg-green-100 text-green-700 border-green-200';
    case 'PENDING_VERIFICATION': return 'bg-yellow-100 text-yellow-700 border-yellow-200';
    case 'MORE_INFO_REQUESTED': return 'bg-orange-100 text-orange-700 border-orange-200';
    case 'REJECTED': return 'bg-red-100 text-red-700 border-red-200';
    default: return 'bg-gray-100 text-gray-700';
  }
};

const getStatusIcon = (status: VerificationStatus) => {
  switch (status) {
    case 'VERIFIED': return ShieldCheck;
    case 'PENDING_VERIFICATION': return Clock;
    case 'MORE_INFO_REQUESTED': return AlertCircle;
    case 'REJECTED': return ShieldAlert;
    default: return ShieldCheck;
  }
};

const getStatusLabel = (status: VerificationStatus) => {
  return status.replace(/_/g, ' ');
};

export default function OrganizationsPage() {
  const [activeFilter, setActiveFilter] = useState<VerificationStatus | 'ALL'>('ALL');
  const [searchQuery, setSearchQuery] = useState('');

  const filteredOrgs = mockOrganizations.filter((org) => {
    const matchesFilter = activeFilter === 'ALL' || org.verificationStatus === activeFilter;
    const matchesSearch = org.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
                          org.contactEmail.toLowerCase().includes(searchQuery.toLowerCase()) ||
                          org.id.toLowerCase().includes(searchQuery.toLowerCase());
    return matchesFilter && matchesSearch;
  });

  // Count stats
  const verifiedCount = mockOrganizations.filter(o => o.verificationStatus === 'VERIFIED').length;
  const pendingCount = mockOrganizations.filter(o => o.verificationStatus === 'PENDING_VERIFICATION').length;
  const rejectedCount = mockOrganizations.filter(o => o.verificationStatus === 'REJECTED').length;

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-[#0D1B2A]">Organizations</h1>
          <p className="text-gray-500 mt-1 text-sm">
            Manage partner organizations and their verification status.
          </p>
        </div>
        <button className="flex items-center justify-center gap-2 bg-[#0D1B2A] hover:bg-[#1B2A3A] text-white px-4 py-2 rounded-lg text-sm font-medium transition-colors">
          <Plus size={16} />
          Register Organization
        </button>
      </div>

      {/* Quick Stats */}
      <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
        <StatCard label="Total Organizations" value={mockOrganizations.length} color="text-[#0D1B2A]" />
        <StatCard label="Verified" value={verifiedCount} color="text-green-600" />
        <StatCard label="Pending" value={pendingCount} color="text-yellow-600" />
        <StatCard label="Rejected" value={rejectedCount} color="text-red-600" />
      </div>

      {/* Filters and Search */}
      <div className="bg-white p-4 rounded-xl border border-gray-200 shadow-sm space-y-4">
        <div className="flex items-center bg-gray-50 border border-gray-200 rounded-lg px-3 py-2">
          <Search size={16} className="text-gray-400 shrink-0" />
          <input
            type="text"
            placeholder="Search by name, email, or ID..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="bg-transparent border-none outline-none ml-2 text-sm w-full"
          />
        </div>

        <div className="flex gap-2 overflow-x-auto pb-1 -mb-1">
          {statusFilters.map((filter) => (
            <button
              key={filter.value}
              onClick={() => setActiveFilter(filter.value)}
              className={cn(
                "px-3 py-1.5 rounded-full text-xs font-medium whitespace-nowrap transition-colors border",
                activeFilter === filter.value
                  ? "bg-[#0D1B2A] text-white border-[#0D1B2A]"
                  : "bg-white text-gray-600 border-gray-200 hover:bg-gray-50"
              )}
            >
              {filter.label}
            </button>
          ))}
        </div>
      </div>

      {/* Organizations Table */}
      <div className="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left text-sm">
            <thead className="bg-gray-50 border-b border-gray-200">
              <tr>
                <th className="px-6 py-3 font-semibold text-gray-600 text-xs uppercase tracking-wider">Organization</th>
                <th className="px-6 py-3 font-semibold text-gray-600 text-xs uppercase tracking-wider">Contact</th>
                <th className="px-6 py-3 font-semibold text-gray-600 text-xs uppercase tracking-wider">Areas</th>
                <th className="px-6 py-3 font-semibold text-gray-600 text-xs uppercase tracking-wider">Staff</th>
                <th className="px-6 py-3 font-semibold text-gray-600 text-xs uppercase tracking-wider">Status</th>
                <th className="px-6 py-3 font-semibold text-gray-600 text-xs uppercase tracking-wider text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {filteredOrgs.map((org) => {
                const StatusIcon = getStatusIcon(org.verificationStatus);
                return (
                  <tr key={org.id} className="hover:bg-gray-50/50 transition-colors">
                    <td className="px-6 py-4">
                      <div className="flex items-center gap-3">
                        <div className="w-10 h-10 rounded-full bg-[#0D1B2A] flex items-center justify-center text-[#D4AF37] font-bold text-sm shrink-0">
                          {org.name.charAt(0)}
                        </div>
                        <div>
                          <div className="font-medium text-gray-900">{org.name}</div>
                          <div className="font-mono text-xs text-gray-400 mt-0.5">{org.id}</div>
                        </div>
                      </div>
                    </td>
                    <td className="px-6 py-4">
                      <div className="text-xs text-gray-700">{org.contactEmail}</div>
                      <div className="text-xs text-gray-500 mt-0.5">{org.contactPhone}</div>
                    </td>
                    <td className="px-6 py-4">
                      <div className="flex flex-wrap gap-1">
                        {org.areasOfOperation.slice(0, 2).map((area) => (
                          <span key={area} className="inline-block px-2 py-0.5 bg-gray-100 text-gray-600 text-xs rounded">
                            {area}
                          </span>
                        ))}
                        {org.areasOfOperation.length > 2 && (
                          <span className="text-xs text-gray-400">+{org.areasOfOperation.length - 2}</span>
                        )}
                      </div>
                    </td>
                    <td className="px-6 py-4">
                      <div className="flex items-center gap-1.5 text-sm text-gray-700">
                        <Users size={14} className="text-gray-400" />
                        {org.staffCount}
                      </div>
                    </td>
                    <td className="px-6 py-4">
                      <span className={cn(
                        "inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full text-xs font-medium border",
                        getStatusStyle(org.verificationStatus)
                      )}>
                        <StatusIcon size={12} />
                        {getStatusLabel(org.verificationStatus)}
                      </span>
                    </td>
                    <td className="px-6 py-4 text-right">
                      <div className="flex items-center justify-end gap-1">
                        <Link 
                          href={`/dashboard/organizations/${org.id}`}
                          className="p-2 text-gray-400 hover:text-blue-600 hover:bg-blue-50 rounded-md transition-colors"
                          title="View"
                        >
                          <Eye size={16} />
                        </Link>
                        <button 
                          className="p-2 text-gray-400 hover:text-gray-700 hover:bg-gray-100 rounded-md transition-colors"
                          title="More Actions"
                        >
                          <MoreVertical size={16} />
                        </button>
                      </div>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>

        {filteredOrgs.length === 0 && (
          <div className="text-center py-12">
            <AlertCircle size={40} className="mx-auto text-gray-300" />
            <p className="mt-3 text-sm font-medium text-gray-900">No organizations found</p>
            <p className="text-xs text-gray-500 mt-1">Try changing the filter or search query.</p>
          </div>
        )}

        <div className="px-6 py-3 border-t border-gray-100 flex items-center justify-between text-xs text-gray-500">
          <span>Showing {filteredOrgs.length} of {mockOrganizations.length} organizations</span>
        </div>
      </div>
    </div>
  );
}

function StatCard({ label, value, color }: { label: string; value: number; color: string }) {
  return (
    <div className="bg-white p-4 rounded-xl border border-gray-200 shadow-sm">
      <p className="text-xs text-gray-500 font-medium">{label}</p>
      <p className={cn("text-2xl font-bold mt-1", color)}>{value}</p>
    </div>
  );
}