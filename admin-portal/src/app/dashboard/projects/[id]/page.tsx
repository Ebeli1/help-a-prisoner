'use client';

import { useParams } from 'next/navigation';
import Link from 'next/link';
import { 
  ArrowLeft, Building2, MapPin, Calendar, User, Clock,
  TrendingUp, CheckCircle2, AlertCircle, Plus, LucideIcon
} from 'lucide-react';
import { cn } from '@/lib/utils';
import { mockProjectDetails } from '@/lib/mockData';
import { ProjectStatus } from '@/lib/types';

const lifecycleStages: ProjectStatus[] = [
  'PROPOSED', 'UNDER_REVIEW', 'APPROVED', 'FUNDRAISING', 
  'FUNDED', 'IMPLEMENTATION', 'COMPLETED', 'IMPACT_REPORTED'
];

export default function ProjectDetailsPage() {
  const params = useParams();
  const projectId = params.id as string;
  const project = mockProjectDetails?.[projectId];

  if (!project) {
    return (
      <div className="text-center py-20">
        <AlertCircle size={48} className="mx-auto text-gray-300" />
        <h2 className="mt-4 text-lg font-semibold text-gray-700">Project Not Found</h2>
        <p className="text-sm text-gray-500 mt-1">The project ID {projectId} does not exist.</p>
        <Link href="/dashboard/projects" className="mt-6 inline-block text-sm text-[#D4AF37] hover:underline">
          ← Back to Projects
        </Link>
      </div>
    );
  }

  const currentIndex = lifecycleStages.indexOf(project.implementationStatus as ProjectStatus);

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center gap-3">
        <Link 
          href="/dashboard/projects"
          className="p-2 text-gray-500 hover:bg-gray-100 rounded-md"
        >
          <ArrowLeft size={20} />
        </Link>
        <div>
          <p className="text-xs font-mono text-gray-400">{project.id}</p>
          <h1 className="text-xl font-bold text-[#0D1B2A]">{project.name}</h1>
        </div>
        <span className={cn(
          "ml-auto inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold border bg-purple-100 text-purple-700 border-purple-200"
        )}>
          {project.implementationStatus.replace(/_/g, ' ')}
        </span>
      </div>

      {/* Lifecycle Indicator */}
      <div className="bg-white p-4 rounded-xl border border-gray-200 shadow-sm overflow-x-auto">
        <div className="flex items-center gap-2 min-w-max">
          {lifecycleStages.map((stage, idx) => {
            const isCurrent = project.implementationStatus === stage;
            const isPast = currentIndex > idx;
            return (
              <div key={stage} className="flex items-center gap-2">
                <div className={cn(
                  "px-3 py-1.5 rounded-full text-xs font-medium whitespace-nowrap",
                  isCurrent ? "bg-[#D4AF37] text-[#0D1B2A]" 
                    : isPast ? "bg-green-100 text-green-700" 
                    : "bg-gray-100 text-gray-400"
                )}>
                  {stage.replace(/_/g, ' ')}
                </div>
                {idx < lifecycleStages.length - 1 && (
                  <div className={cn(
                    "w-6 h-0.5",
                    isPast ? "bg-green-400" : "bg-gray-200"
                  )} />
                )}
              </div>
            );
          })}
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* LEFT COLUMN */}
        <div className="lg:col-span-2 space-y-6">
          
          {/* Overview Card */}
          <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
            <h2 className="text-base font-bold text-[#0D1B2A] mb-4">Overview</h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <DetailRow icon={Building2} label="Organization" value={project.organization} />
              <DetailRow icon={MapPin} label="Facility" value={project.facilityName} />
              <DetailRow icon={User} label="Project Owner" value={project.projectOwner} />
              <DetailRow icon={Calendar} label="Start Date" value={project.startDate} />
            </div>

            <div className="mt-6 pt-6 border-t border-gray-100">
              <h3 className="text-sm font-semibold text-gray-700 mb-2">Purpose</h3>
              <p className="text-sm text-gray-600 leading-relaxed">{project.purpose}</p>
            </div>
          </div>

          {/* Implementation Updates */}
          <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
            <div className="flex items-center justify-between mb-4">
              <h2 className="text-base font-bold text-[#0D1B2A]">Implementation Updates</h2>
              <button className="flex items-center gap-1.5 text-xs font-semibold text-[#D4AF37] hover:underline">
                <Plus size={14} />
                Add Update
              </button>
            </div>
            <div className="space-y-3">
              {project.updates.map((update, i) => (
                <div key={i} className="flex items-start justify-between py-3 border-b border-gray-50 last:border-0">
                  <div className="flex-1">
                    <p className="text-sm text-gray-700">{update.update}</p>
                    <p className="text-xs text-gray-400 mt-1">{update.date}</p>
                  </div>
                  <span className={cn(
                    "inline-flex items-center px-2 py-0.5 rounded text-xs font-medium border",
                    update.status === 'APPROVED' 
                      ? "bg-green-50 text-green-700 border-green-200"
                      : "bg-yellow-50 text-yellow-700 border-yellow-200"
                  )}>
                    {update.status}
                  </span>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* RIGHT COLUMN */}
        <div className="space-y-6">
          
          {/* Funding Card */}
          <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
            <div className="flex items-center gap-2 mb-4">
              <TrendingUp size={18} className="text-[#D4AF37]" />
              <h2 className="text-base font-bold text-[#0D1B2A]">Funding</h2>
            </div>
            <div className="space-y-3">
              <div className="flex justify-between text-sm">
                <span className="text-gray-500">Target</span>
                <span className="font-semibold text-[#0D1B2A]">₦{project.target.toLocaleString()}</span>
              </div>
              <div className="flex justify-between text-sm">
                <span className="text-gray-500">Raised</span>
                <span className="font-semibold text-[#0D1B2A]">₦{project.raised.toLocaleString()}</span>
              </div>
              <div className="flex justify-between text-sm">
                <span className="text-gray-500">Funding Status</span>
                <span className={cn(
                  "font-semibold px-2 py-0.5 rounded text-xs border",
                  project.fundingStatus === 'FUNDED' ? "text-emerald-700 bg-emerald-50 border-emerald-200" :
                  project.fundingStatus === 'PARTIALLY_FUNDED' ? "text-yellow-700 bg-yellow-50 border-yellow-200" :
                  "text-gray-600 bg-gray-50 border-gray-200"
                )}>
                  {project.fundingStatus.replace('_', ' ')}
                </span>
              </div>

              <div className="pt-3 mt-3 border-t border-gray-100">
                <div className="w-full bg-gray-200 rounded-full h-2">
                  <div 
                    className="bg-[#D4AF37] h-2 rounded-full" 
                    style={{ width: `${Math.min((project.raised / project.target) * 100, 100)}%` }}
                  />
                </div>
                <p className="text-xs text-gray-500 mt-2">
                  {((project.raised / project.target) * 100).toFixed(0)}% funded
                </p>
              </div>
            </div>
          </div>

          {/* Implementation Progress */}
          <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
            <div className="flex items-center gap-2 mb-4">
              <CheckCircle2 size={18} className="text-[#D4AF37]" />
              <h2 className="text-base font-bold text-[#0D1B2A]">Implementation</h2>
            </div>
            <div className="space-y-3">
              <div className="flex justify-between text-sm">
                <span className="text-gray-500">Current Stage</span>
                <span className="font-semibold text-[#0D1B2A]">
                  {project.implementationStatus.replace(/_/g, ' ')}
                </span>
              </div>
              <div className="flex justify-between text-sm">
                <span className="text-gray-500">Expected Completion</span>
                <span className="font-semibold text-[#0D1B2A]">{project.expectedCompletion}</span>
              </div>
              
              <div className="pt-3 mt-3 border-t border-gray-100">
                <div className="flex justify-between text-xs mb-1">
                  <span className="text-gray-500">Progress</span>
                  <span className="font-semibold text-[#0D1B2A]">{project.progress}%</span>
                </div>
                <div className="w-full bg-gray-200 rounded-full h-2">
                  <div 
                    className="bg-[#D4AF37] h-2 rounded-full" 
                    style={{ width: `${project.progress}%` }}
                  />
                </div>
              </div>
            </div>
          </div>

          {/* Impact Card (only if reported) */}
          {project.impact && (
            <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
              <div className="flex items-center gap-2 mb-4">
                <User size={18} className="text-[#D4AF37]" />
                <h2 className="text-base font-bold text-[#0D1B2A]">Impact</h2>
              </div>
              <div className="space-y-3">
                <InfoRow label="Participants" value={project.impact.participants.toString()} />
                <InfoRow label="Training Sessions" value={project.impact.trainingSessions.toString()} />
                {project.impact.outcome && (
                  <div className="pt-3 border-t border-gray-100">
                    <p className="text-xs text-gray-500 mb-1">Outcome</p>
                    <p className="text-sm text-gray-700">{project.impact.outcome}</p>
                  </div>
                )}
              </div>
            </div>
          )}

          {/* Audit Trail Placeholder */}
          <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
            <div className="flex items-center gap-2 mb-4">
              <Clock size={18} className="text-[#D4AF37]" />
              <h2 className="text-base font-bold text-[#0D1B2A]">History</h2>
            </div>
            <p className="text-xs text-gray-500">
              Activity log for this project will appear here.
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}

// Helpers
function DetailRow({ 
  icon: Icon, 
  label, 
  value 
}: { 
  icon: LucideIcon; 
  label: string; 
  value: string 
}) {
  return (
    <div className="flex items-start gap-3">
      <div className="p-2 bg-gray-50 rounded-md">
        <Icon size={16} className="text-[#D4AF37]" />
      </div>
      <div>
        <p className="text-xs text-gray-400 uppercase font-semibold">{label}</p>
        <p className="text-sm text-gray-800 font-medium mt-0.5">{value}</p>
      </div>
    </div>
  );
}

function InfoRow({ label, value }: { label: string; value: string }) {
  return (
    <div className="flex justify-between gap-3 text-sm">
      <span className="text-gray-500">{label}</span>
      <span className="font-medium text-gray-800 text-right">{value}</span>
    </div>
  );
}