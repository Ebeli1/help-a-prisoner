'use client';

import { useState } from 'react';
import Link from 'next/link';
import { 
  Plus, Filter, Search, MoreVertical, Eye, AlertCircle
} from 'lucide-react';
import { cn } from '@/lib/utils';
import { mockProjects } from '@/lib/mockData';
import { ProjectStatus } from '@/lib/types';

const statusFilters: { label: string; value: ProjectStatus | 'ALL' }[] = [
  { label: 'All', value: 'ALL' },
  { label: 'Proposed', value: 'PROPOSED' },
  { label: 'Under Review', value: 'UNDER_REVIEW' },
  { label: 'Approved', value: 'APPROVED' },
  { label: 'Fundraising', value: 'FUNDRAISING' },
  { label: 'Funded', value: 'FUNDED' },
  { label: 'Implementation', value: 'IMPLEMENTATION' },
  { label: 'Completed', value: 'COMPLETED' },
];

const getStatusStyle = (status: ProjectStatus) => {
  switch (status) {
    case 'PROPOSED': return 'bg-gray-100 text-gray-700 border-gray-200';
    case 'UNDER_REVIEW': return 'bg-yellow-100 text-yellow-700 border-yellow-200';
    case 'APPROVED': return 'bg-blue-100 text-blue-700 border-blue-200';
    case 'FUNDRAISING': return 'bg-orange-100 text-orange-700 border-orange-200';
    case 'FUNDED': return 'bg-emerald-100 text-emerald-700 border-emerald-200';
    case 'IMPLEMENTATION': return 'bg-purple-100 text-purple-700 border-purple-200';
    case 'COMPLETED': return 'bg-indigo-100 text-indigo-700 border-indigo-200';
    case 'IMPACT_REPORTED': return 'bg-green-100 text-green-700 border-green-200';
    default: return 'bg-gray-100 text-gray-700';
  }
};

const getFundingStyle = (status: string) => {
  switch (status) {
    case 'FUNDED': return 'text-emerald-700 bg-emerald-50 border-emerald-200';
    case 'PARTIALLY_FUNDED': return 'text-yellow-700 bg-yellow-50 border-yellow-200';
    case 'UNFUNDED': return 'text-gray-600 bg-gray-50 border-gray-200';
    default: return 'bg-gray-100 text-gray-700';
  }
};

export default function ProjectsPage() {
  const [activeFilter, setActiveFilter] = useState<ProjectStatus | 'ALL'>('ALL');
  const [searchQuery, setSearchQuery] = useState('');

  const filteredProjects = mockProjects.filter((project) => {
    const matchesFilter = activeFilter === 'ALL' || project.implementationStatus === activeFilter;
    const matchesSearch = project.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
                          project.organization.toLowerCase().includes(searchQuery.toLowerCase()) ||
                          project.id.toLowerCase().includes(searchQuery.toLowerCase());
    return matchesFilter && matchesSearch;
  });

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-[#0D1B2A]">Projects</h1>
          <p className="text-gray-500 mt-1 text-sm">
            Track the pipeline of initiatives from proposal to completion.
          </p>
        </div>
        <button className="flex items-center justify-center gap-2 bg-[#0D1B2A] hover:bg-[#1B2A3A] text-white px-4 py-2 rounded-lg text-sm font-medium transition-colors">
          <Plus size={16} />
          New Project
        </button>
      </div>

      {/* Filters and Search */}
      <div className="bg-white p-4 rounded-xl border border-gray-200 shadow-sm space-y-4">
        <div className="flex flex-col md:flex-row gap-3">
          <div className="flex-1 flex items-center bg-gray-50 border border-gray-200 rounded-lg px-3 py-2">
            <Search size={16} className="text-gray-400 shrink-0" />
            <input
              type="text"
              placeholder="Search by project name, organization, or ID..."
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

      {/* Projects Table */}
      <div className="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left text-sm">
            <thead className="bg-gray-50 border-b border-gray-200">
              <tr>
                <th className="px-6 py-3 font-semibold text-gray-600 text-xs uppercase tracking-wider">ID</th>
                <th className="px-6 py-3 font-semibold text-gray-600 text-xs uppercase tracking-wider">Project</th>
                <th className="px-6 py-3 font-semibold text-gray-600 text-xs uppercase tracking-wider">Funding</th>
                <th className="px-6 py-3 font-semibold text-gray-600 text-xs uppercase tracking-wider">Progress</th>
                <th className="px-6 py-3 font-semibold text-gray-600 text-xs uppercase tracking-wider">Status</th>
                <th className="px-6 py-3 font-semibold text-gray-600 text-xs uppercase tracking-wider text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {filteredProjects.map((project) => (
                <tr key={project.id} className="hover:bg-gray-50/50 transition-colors">
                  <td className="px-6 py-4 font-mono text-xs text-gray-500">
                    {project.id}
                  </td>
                  <td className="px-6 py-4">
                    <div className="font-medium text-gray-900">{project.name}</div>
                    <div className="text-xs text-gray-500 mt-0.5">{project.organization}</div>
                  </td>
                  <td className="px-6 py-4">
                    <span className={cn(
                      "inline-flex items-center px-2 py-0.5 rounded text-xs font-medium border",
                      getFundingStyle(project.fundingStatus)
                    )}>
                      {project.fundingStatus.replace('_', ' ')}
                    </span>
                    <div className="text-xs text-gray-500 mt-1">
                      ₦{(project.raised / 1000000).toFixed(1)}M / ₦{(project.target / 1000000).toFixed(1)}M
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <div className="w-24">
                      <div className="flex justify-between text-xs mb-1">
                        <span className="text-gray-500">{project.progress}%</span>
                      </div>
                      <div className="w-full bg-gray-200 rounded-full h-1.5">
                        <div 
                          className="bg-[#D4AF37] h-1.5 rounded-full" 
                          style={{ width: `${project.progress}%` }}
                        />
                      </div>
                    </div>
                  </td>
                  <td className="px-6 py-4">
                    <span className={cn(
                      "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium border",
                      getStatusStyle(project.implementationStatus)
                    )}>
                      {project.implementationStatus.replace(/_/g, ' ')}
                    </span>
                  </td>
                  <td className="px-6 py-4 text-right">
                    <div className="flex items-center justify-end gap-1">
                      <Link 
                        href={`/dashboard/projects/${project.id}`}
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
              ))}
            </tbody>
          </table>
        </div>

        {filteredProjects.length === 0 && (
          <div className="text-center py-12">
            <AlertCircle size={40} className="mx-auto text-gray-300" />
            <p className="mt-3 text-sm font-medium text-gray-900">No projects found</p>
            <p className="text-xs text-gray-500 mt-1">Try changing the filter or search query.</p>
          </div>
        )}

        <div className="px-6 py-3 border-t border-gray-100 flex items-center justify-between text-xs text-gray-500">
          <span>Showing {filteredProjects.length} of {mockProjects.length} projects</span>
        </div>
      </div>
    </div>
  );
}