'use client';

import { useState } from 'react';
import { useParams, useRouter } from 'next/navigation';
import Link from 'next/link';
import { 
  ArrowLeft, Building2, MapPin, Target, FileText,
  CheckCircle2, XCircle, AlertCircle, Clock, User, Shield,
  LucideIcon
} from 'lucide-react';
import { cn } from '@/lib/utils';
import { mockCampaignDetails } from '@/lib/mockData';
import { CampaignStatus } from '@/lib/types';

// The Campaign lifecycle flow (Section 6.10)
const statusFlow: CampaignStatus[] = [
  'DRAFT', 'PENDING_REVIEW', 'APPROVED', 'ACTIVE', 'FUNDED', 'COMPLETED'
];

export default function CampaignDetailsPage() {
  const params = useParams();
  const router = useRouter();
  const campaignId = params.id as string;
  
  const [reviewMode, setReviewMode] = useState<'none' | 'changes' | 'reject'>('none');
  const [reason, setReason] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);

  const campaign = mockCampaignDetails[campaignId];

  if (!campaign) {
    return (
      <div className="text-center py-20">
        <AlertCircle size={48} className="mx-auto text-gray-300" />
        <h2 className="mt-4 text-lg font-semibold text-gray-700">Campaign Not Found</h2>
        <p className="text-sm text-gray-500 mt-1">The campaign ID {campaignId} does not exist.</p>
        <Link href="/dashboard/campaigns" className="mt-6 inline-block text-sm text-[#D4AF37] hover:underline">
          ← Back to Campaigns
        </Link>
      </div>
    );
  }

  const handleApprove = () => {
    setIsSubmitting(true);
    // TODO: Call API to approve
    setTimeout(() => {
      setIsSubmitting(false);
      router.push('/dashboard/campaigns');
    }, 1000);
  };

  const handleSubmitReview = () => {
    if (!reason.trim()) return;
    setIsSubmitting(true);
    // TODO: Call API to request changes / reject
    setTimeout(() => {
      setIsSubmitting(false);
      setReviewMode('none');
      setReason('');
      router.push('/dashboard/campaigns');
    }, 1000);
  };

  // Fix for the `any` cast: cast to CampaignStatus array first
  const currentStatusIndex = statusFlow.indexOf(campaign.status as CampaignStatus);

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center gap-3">
        <Link 
          href="/dashboard/campaigns"
          className="p-2 text-gray-500 hover:bg-gray-100 rounded-md"
        >
          <ArrowLeft size={20} />
        </Link>
        <div>
          <p className="text-xs font-mono text-gray-400">{campaign.id}</p>
          <h1 className="text-xl font-bold text-[#0D1B2A]">{campaign.title}</h1>
        </div>
        <span className={cn(
          "ml-auto inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold border",
          campaign.status === 'PENDING_REVIEW' 
            ? "bg-yellow-100 text-yellow-700 border-yellow-200" 
            : "bg-gray-100 text-gray-700"
        )}>
          {campaign.status.replace('_', ' ')}
        </span>
      </div>

      {/* Status Flow Indicator */}
      <div className="bg-white p-4 rounded-xl border border-gray-200 shadow-sm overflow-x-auto">
        <div className="flex items-center gap-2 min-w-max">
          {statusFlow.map((status, idx) => {
            const isCurrent = campaign.status === status;
            const isPast = currentStatusIndex > idx;
            const isAlternative = ['REJECTED', 'SUSPENDED'].includes(campaign.status);
            
            return (
              <div key={status} className="flex items-center gap-2">
                <div className={cn(
                  "px-3 py-1.5 rounded-full text-xs font-medium whitespace-nowrap",
                  isCurrent ? "bg-[#D4AF37] text-[#0D1B2A]" 
                    : isPast && !isAlternative ? "bg-green-100 text-green-700" 
                    : "bg-gray-100 text-gray-400"
                )}>
                  {status.replace('_', ' ')}
                </div>
                {idx < statusFlow.length - 1 && (
                  <div className={cn(
                    "w-6 h-0.5",
                    isPast && !isAlternative ? "bg-green-400" : "bg-gray-200"
                  )} />
                )}
              </div>
            );
          })}
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* LEFT COLUMN: Campaign Details */}
        <div className="lg:col-span-2 space-y-6">
          
          {/* Overview Card */}
          <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
            <h2 className="text-base font-bold text-[#0D1B2A] mb-4">Campaign Overview</h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <DetailRow icon={Building2} label="Organization" value={campaign.organization} />
              <DetailRow icon={Target} label="Category" value={campaign.category} />
              <DetailRow icon={FileText} label="Project" value={campaign.projectName} />
              <DetailRow icon={MapPin} label="Facility / Location" value={campaign.facilityName} />
            </div>

            <div className="mt-6 pt-6 border-t border-gray-100">
              <h3 className="text-sm font-semibold text-gray-700 mb-2">Description</h3>
              <p className="text-sm text-gray-600 leading-relaxed">{campaign.description}</p>
            </div>

            <div className="mt-6 pt-6 border-t border-gray-100">
              <h3 className="text-sm font-semibold text-gray-700 mb-2">Expected Outcome</h3>
              <p className="text-sm text-gray-600 leading-relaxed">{campaign.expectedOutcome}</p>
            </div>
          </div>

          {/* Use of Funds Card */}
          <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
            <div className="flex items-center justify-between mb-4">
              <h2 className="text-base font-bold text-[#0D1B2A]">Use of Funds</h2>
              <span className="text-sm font-bold text-[#D4AF37]">
                Total: ₦{campaign.target.toLocaleString()}
              </span>
            </div>
            <div className="space-y-3">
              {campaign.useOfFunds.map((fund, i) => (
                <div key={i} className="flex items-start justify-between py-2 border-b border-gray-50 last:border-0">
                  <span className="text-sm text-gray-600 flex-1 pr-4">{fund.item}</span>
                  <span className="text-sm font-semibold text-[#0D1B2A] whitespace-nowrap">
                    ₦{fund.amount.toLocaleString()}
                  </span>
                </div>
              ))}
            </div>
          </div>

          {/* Supporting Documents & Photos */}
          <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
            <h2 className="text-base font-bold text-[#0D1B2A] mb-4">Supporting Evidence</h2>
            
            <h3 className="text-xs font-semibold text-gray-500 uppercase mb-3">Documents</h3>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-3 mb-6">
              {campaign.supportingDocs.map((doc, i) => (
                <a key={i} href={doc.url} className="flex items-center gap-3 p-3 bg-gray-50 rounded-lg hover:bg-gray-100 transition-colors">
                  <FileText size={18} className="text-[#D4AF37] shrink-0" />
                  <span className="text-sm text-gray-700 truncate">{doc.name}</span>
                </a>
              ))}
            </div>

            <h3 className="text-xs font-semibold text-gray-500 uppercase mb-3">Photos</h3>
            <div className="grid grid-cols-2 md:grid-cols-3 gap-3">
              {campaign.photos.map((photo, i) => (
                <div key={i} className="aspect-video bg-gray-100 rounded-lg overflow-hidden">
                  {/* eslint-disable-next-line @next/next/no-img-element */}
                  <img src={photo} alt={`Campaign photo ${i + 1}`} className="w-full h-full object-cover" />
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* RIGHT COLUMN: Sidebar */}
        <div className="space-y-6">
          
          {/* Verification Info Card */}
          <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
            <div className="flex items-center gap-2 mb-4">
              <Shield size={18} className="text-[#D4AF37]" />
              <h2 className="text-base font-bold text-[#0D1B2A]">Verification Info</h2>
            </div>
            <div className="space-y-3 text-sm">
              <InfoRow label="Submitted By" value={campaign.verificationInfo.submittedBy} />
              <InfoRow label="Submission Date" value={campaign.verificationInfo.submittedDate} />
              <InfoRow label="Parent Organization" value={campaign.verificationInfo.verifiedByOrg} />
              <InfoRow label="Contact Person" value={campaign.verificationInfo.contactPerson} />
              <InfoRow label="Contact Email" value={campaign.verificationInfo.contactEmail} />
            </div>
          </div>

          {/* Review Decision Panel (Section 6.9) */}
          {campaign.status === 'PENDING_REVIEW' && (
            <div className="bg-white p-6 rounded-xl border-2 border-[#D4AF37] shadow-lg sticky top-6">
              <h2 className="text-base font-bold text-[#0D1B2A] mb-1">Review Decision</h2>
              <p className="text-xs text-gray-500 mb-4">
                This action will be recorded in the audit log.
              </p>

              {reviewMode === 'none' ? (
                <div className="space-y-2">
                  <button
                    onClick={handleApprove}
                    disabled={isSubmitting}
                    className="w-full flex items-center justify-center gap-2 bg-green-600 hover:bg-green-700 text-white py-2.5 rounded-lg text-sm font-semibold transition-colors disabled:opacity-50"
                  >
                    <CheckCircle2 size={16} />
                    Approve Campaign
                  </button>
                  <button
                    onClick={() => setReviewMode('changes')}
                    className="w-full flex items-center justify-center gap-2 bg-yellow-500 hover:bg-yellow-600 text-white py-2.5 rounded-lg text-sm font-semibold transition-colors"
                  >
                    <AlertCircle size={16} />
                    Request Changes
                  </button>
                  <button
                    onClick={() => setReviewMode('reject')}
                    className="w-full flex items-center justify-center gap-2 bg-red-600 hover:bg-red-700 text-white py-2.5 rounded-lg text-sm font-semibold transition-colors"
                  >
                    <XCircle size={16} />
                    Reject Campaign
                  </button>
                </div>
              ) : (
                <div className="space-y-4">
                  <div>
                    <label className="block text-xs font-semibold text-gray-700 mb-2">
                      {reviewMode === 'reject' ? 'Reason for Rejection (Required)' : 'Changes Required (Required)'}
                    </label>
                    <textarea
                      value={reason}
                      onChange={(e) => setReason(e.target.value)}
                      rows={5}
                      placeholder="Provide a detailed reason. This will be visible to the organization."
                      className="w-full text-sm border border-gray-300 rounded-lg p-3 outline-none focus:border-[#D4AF37] resize-none"
                    />
                  </div>
                  <div className="flex gap-2">
                    <button
                      onClick={() => { setReviewMode('none'); setReason(''); }}
                      className="flex-1 py-2 text-sm font-medium text-gray-600 border border-gray-200 rounded-lg hover:bg-gray-50"
                    >
                      Cancel
                    </button>
                    <button
                      onClick={handleSubmitReview}
                      disabled={!reason.trim() || isSubmitting}
                      className={cn(
                        "flex-1 py-2 text-sm font-semibold text-white rounded-lg disabled:opacity-50",
                        reviewMode === 'reject' ? "bg-red-600 hover:bg-red-700" : "bg-yellow-500 hover:bg-yellow-600"
                      )}
                    >
                      {isSubmitting ? 'Submitting...' : 'Submit'}
                    </button>
                  </div>
                </div>
              )}
            </div>
          )}

          {/* Audit Trail Card */}
          <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
            <div className="flex items-center gap-2 mb-4">
              <Clock size={18} className="text-[#D4AF37]" />
              <h2 className="text-base font-bold text-[#0D1B2A]">Audit Trail</h2>
            </div>
            <div className="space-y-4">
              {campaign.auditTrail.map((entry, i) => (
                <div key={i} className="flex gap-3 text-xs">
                  <div className="w-1.5 h-1.5 rounded-full bg-[#D4AF37] mt-1.5 shrink-0" />
                  <div>
                    <p className="font-semibold text-gray-800">{entry.action.replace(/_/g, ' ')}</p>
                    <p className="text-gray-500 mt-0.5 flex items-center gap-1">
                      <User size={10} /> {entry.actor} • {entry.date}
                    </p>
                    {entry.note && (
                      <p className="text-gray-400 mt-1 italic">
                        &ldquo;{entry.note}&rdquo;
                      </p>
                    )}
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}

// Helper Components
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
    <div className="flex justify-between gap-3">
      <span className="text-gray-500">{label}</span>
      <span className="font-medium text-gray-800 text-right">{value}</span>
    </div>
  );
}