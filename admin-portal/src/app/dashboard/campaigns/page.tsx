'use client';

import { useState } from 'react';
import Link from 'next/link';
import { 
  Plus, Filter, Search, MoreVertical, Eye, AlertCircle
} from 'lucide-react';
import { cn } from '@/lib/utils';
import { mockCampaigns } from '@/lib/mockData';
import { CampaignStatus } from '@/lib/types';

const statusFilters: { label: string; value: CampaignStatus | 'ALL' }[] = [
  { label: 'All', value: 'ALL' },
  { label: 'Draft', value: 'DRAFT' },
  { label: 'Pending Review', value: 'PENDING_REVIEW' },
  { label: 'Approved', value: 'APPROVED' },
  { label: 'Active', value: 'ACTIVE' },
  { label: 'Funded', value: 'FUNDED' },
  { label: 'Completed', value: 'COMPLETED' },
  { label: 'Suspended', value: 'SUSPENDED' },
  { label: 'Rejected', value: 'REJECTED' },
];

const getStatusStyle = (status: CampaignStatus) => {
  switch (status) {
    case 'ACTIVE': return 'bg-green-100 text-green-700 border-green-200';
    case 'APPROVED': return 'bg-blue-100 text-blue-700 border-blue-200';
    case 'PENDING_REVIEW': return 'bg-yellow-100 text-yellow-700 border-yellow-200';
    case 'DRAFT': return 'bg-gray-100 text-gray-700 border-gray-200';
    case 'FUNDED': return 'bg-emerald-100 text-emerald-700 border-emerald-200';
    case 'COMPLETED': return 'bg-indigo-100 text-indigo-700 border-indigo-200';
    case 'SUSPENDED': return 'bg-orange-100 text-orange-700 border-orange-200';
    case 'REJECTED': return 'bg-red-100 text-red-700 border-red-200';
    default: return 'bg-gray-100 text-gray-700';
  }
};

const getStatusLabel = (status: CampaignStatus) => {
  return status.replace('_', ' ');
};

export default function CampaignsPage() {
  const [activeFilter, setActiveFilter] = useState<CampaignStatus | 'ALL'>('ALL');
  const [searchQuery, setSearchQuery] = useState('');

  const filteredCampaigns = mockCampaigns.filter((campaign) => {
    const matchesFilter = activeFilter === 'ALL' || campaign.status === activeFilter;
    const matchesSearch = campaign.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
                          campaign.organization.toLowerCase().includes(searchQuery.toLowerCase()) ||
                          campaign.id.toLowerCase().includes(searchQuery.toLowerCase());
    return matchesFilter && matchesSearch;
  });

  return (
    <div className="space-y-6">
      {/* Page Header */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-[#0D1B2A]">Campaigns</h1>
          <p className="text-gray-500 mt-1 text-sm">
            Manage and review all fundraising campaigns.
          </p>
        </div>
        <button className="flex items-center justify-center gap-2 bg-[#0D1B2A] hover:bg-[#1B2A3A] text-white px-4 py-2 rounded-lg text-sm font-medium transition-colors">
          <Plus size={16} />
          New Campaign
        </button>
      </div>

      {/* Filters and Search */}
      <div className="bg-white p-4 rounded-xl border border-gray-200 shadow-sm space-y-4">
        <div className="flex flex-col md:flex-row gap-3">
          <div className="flex-1 flex items-center bg-gray-50 border border-gray-200 rounded-lg px-3 py-2">
            <Search size={16} className="text-gray-400 shrink-0" />
            <input
              type="text"
              placeholder="Search by title, organization, or ID..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="bg-transparent border-none outline-none ml-2 text-sm w-full"
            />
          </div>
          <button className="flex items-center justify-center gap-2 px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-200 rounded-lg hover:bg-gray-50">
            <Filter size={16} />
            Advanced Filters
          </button>
        </div>

        {/* Status Tabs */}
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

      {/* Campaigns Table */}
      <div className="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left text-sm">
            <thead className="bg-gray-50 border-b border-gray-200">
              <tr>
                <th className="px-6 py-3 font-semibold text-gray-600 text-xs uppercase tracking-wider">ID</th>
                <th className="px-6 py-3 font-semibold text-gray-600 text-xs uppercase tracking-wider">Campaign</th>
                <th className="px-6 py-3 font-semibold text-gray-600 text-xs uppercase tracking-wider">Organization</th>
                <th className="px-6 py-3 font-semibold text-gray-600 text-xs uppercase tracking-wider">Progress</th>
                <th className="px-6 py-3 font-semibold text-gray-600 text-xs uppercase tracking-wider">Status</th>
                <th className="px-6 py-3 font-semibold text-gray-600 text-xs uppercase tracking-wider text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {filteredCampaigns.map((campaign) => {
                const progress = Math.min((campaign.raised / campaign.target) * 100, 100);
                return (
                  <tr key={campaign.id} className="hover:bg-gray-50/50 transition-colors">
                    <td className="px-6 py-4 font-mono text-xs text-gray-500">
                      {campaign.id}
                    </td>
                    <td className="px-6 py-4">
                      <div className="font-medium text-gray-900">{campaign.title}</div>
                      <div className="text-xs text-gray-500 mt-0.5">{campaign.category}</div>
                    </td>
                    <td className="px-6 py-4 text-gray-700">
                      {campaign.organization}
                    </td>
                    <td className="px-6 py-4">
                      <div className="w-32">
                        <div className="flex justify-between text-xs mb-1">
                          <span className="text-gray-500">{progress.toFixed(0)}%</span>
                          <span className="text-gray-500">
                            ₦{(campaign.raised / 1000000).toFixed(1)}M / ₦{(campaign.target / 1000000).toFixed(1)}M
                          </span>
                        </div>
                        <div className="w-full bg-gray-200 rounded-full h-1.5">
                          <div 
                            className="bg-[#D4AF37] h-1.5 rounded-full" 
                            style={{ width: `${progress}%` }}
                          />
                        </div>
                      </div>
                    </td>
                    <td className="px-6 py-4">
                      <span className={cn(
                        "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium border",
                        getStatusStyle(campaign.status)
                      )}>
                        {getStatusLabel(campaign.status)}
                      </span>
                    </td>
                    <td className="px-6 py-4 text-right">
                      <div className="flex items-center justify-end gap-1">
                        <Link 
                          href={`/dashboard/campaigns/${campaign.id}`}
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

        {filteredCampaigns.length === 0 && (
          <div className="text-center py-12">
            <AlertCircle size={40} className="mx-auto text-gray-300" />
            <p className="mt-3 text-sm font-medium text-gray-900">No campaigns found</p>
            <p className="text-xs text-gray-500 mt-1">Try changing the filter or search query.</p>
          </div>
        )}

        {/* Table Footer */}
        <div className="px-6 py-3 border-t border-gray-100 flex items-center justify-between text-xs text-gray-500">
          <span>Showing {filteredCampaigns.length} of {mockCampaigns.length} campaigns</span>
          <div className="flex gap-2">
            <button className="px-3 py-1 border border-gray-200 rounded-md hover:bg-gray-50 disabled:opacity-50" disabled>Previous</button>
            <button className="px-3 py-1 border border-gray-200 rounded-md hover:bg-gray-50 disabled:opacity-50" disabled>Next</button>
          </div>
        </div>
      </div>
    </div>
  );
}