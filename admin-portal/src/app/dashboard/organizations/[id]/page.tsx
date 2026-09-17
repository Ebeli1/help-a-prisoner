'use client';

import { useState } from 'react';
import { useParams, useRouter } from 'next/navigation';
import Link from 'next/link';
import { 
  ArrowLeft, Building2, Globe, MapPin, Mail, Phone, Calendar, User,
  FileText, Users, Shield, AlertCircle, Clock,
  ShieldCheck, ShieldAlert, LucideIcon
} from 'lucide-react';
import { cn } from '@/lib/utils';
import { mockOrganizationDetails, mockOrganizations, VerificationStatus } from '@/lib/mockData';

export default function OrganizationDetailsPage() {
  const params = useParams();
  const router = useRouter();
  const orgId = params.id as string;
  
  const [reviewMode, setReviewMode] = useState<'none' | 'info' | 'reject'>('none');
  const [reason, setReason] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);

  // Fallback to list data if detail data not available
  const baseOrg = mockOrganizations.find(o => o.id === orgId);
  const org = mockOrganizationDetails?.[orgId];

  if (!baseOrg) {
    return (
      <div className="text-center py-20">
        <AlertCircle size={48} className="mx-auto text-gray-300" />
        <h2 className="mt-4 text-lg font-semibold text-gray-700">Organization Not Found</h2>
        <p className="text-sm text-gray-500 mt-1">The organization ID {orgId} does not exist.</p>
        <Link href="/dashboard/organizations" className="mt-6 inline-block text-sm text-[#D4AF37] hover:underline">
          ← Back to Organizations
        </Link>
      </div>
    );
  }

  const handleVerify = () => {
    setIsSubmitting(true);
    setTimeout(() => {
      setIsSubmitting(false);
      router.push('/dashboard/organizations');
    }, 1000);
  };

  const handleSubmitReview = () => {
    if (!reason.trim()) return;
    setIsSubmitting(true);
    setTimeout(() => {
      setIsSubmitting(false);
      setReviewMode('none');
      setReason('');
      router.push('/dashboard/organizations');
    }, 1000);
  };

  const getStatusStyle = (status: VerificationStatus) => {
    switch (status) {
      case 'VERIFIED': return 'bg-green-100 text-green-700 border-green-200';
      case 'PENDING_VERIFICATION': return 'bg-yellow-100 text-yellow-700 border-yellow-200';
      case 'MORE_INFO_REQUESTED': return 'bg-orange-100 text-orange-700 border-orange-200';
      case 'REJECTED': return 'bg-red-100 text-red-700 border-red-200';
      default: return 'bg-gray-100 text-gray-700';
    }
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center gap-3">
        <Link 
          href="/dashboard/organizations"
          className="p-2 text-gray-500 hover:bg-gray-100 rounded-md"
        >
          <ArrowLeft size={20} />
        </Link>
        <div className="w-12 h-12 rounded-full bg-[#0D1B2A] flex items-center justify-center text-[#D4AF37] font-bold text-lg shrink-0">
          {baseOrg.name.charAt(0)}
        </div>
        <div>
          <p className="text-xs font-mono text-gray-400">{baseOrg.id}</p>
          <h1 className="text-xl font-bold text-[#0D1B2A]">{baseOrg.name}</h1>
        </div>
        <span className={cn(
          "ml-auto inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold border",
          getStatusStyle(baseOrg.verificationStatus)
        )}>
          {baseOrg.verificationStatus.replace(/_/g, ' ')}
        </span>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* LEFT COLUMN */}
        <div className="lg:col-span-2 space-y-6">
          
          {/* Overview */}
          <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
            <h2 className="text-base font-bold text-[#0D1B2A] mb-4">Organization Overview</h2>
            <p className="text-sm text-gray-600 leading-relaxed mb-6">{baseOrg.description}</p>
            
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <DetailRow icon={Mail} label="Email" value={baseOrg.contactEmail} />
              <DetailRow icon={Phone} label="Phone" value={baseOrg.contactPhone} />
              <DetailRow icon={MapPin} label="Areas of Operation" value={baseOrg.areasOfOperation.join(', ')} />
              <DetailRow icon={Calendar} label="Registered" value={baseOrg.dateRegistered} />
              {org && (
                <>
                  <DetailRow icon={Globe} label="Website" value={org.website} />
                  <DetailRow icon={Building2} label="Registration #" value={org.registrationNumber} />
                </>
              )}
            </div>
          </div>

          {/* Authorized Representative */}
          {org && (
            <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
              <div className="flex items-center gap-2 mb-4">
                <User size={18} className="text-[#D4AF37]" />
                <h2 className="text-base font-bold text-[#0D1B2A]">Authorized Representative</h2>
              </div>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <DetailRow icon={User} label="Name" value={org.authorizedRepresentative.name} />
                <DetailRow icon={Shield} label="Title" value={org.authorizedRepresentative.title} />
                <DetailRow icon={Mail} label="Email" value={org.authorizedRepresentative.email} />
                <DetailRow icon={Phone} label="Phone" value={org.authorizedRepresentative.phone} />
              </div>
            </div>
          )}

          {/* Supporting Documents */}
          {org && (
            <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
              <div className="flex items-center gap-2 mb-4">
                <FileText size={18} className="text-[#D4AF37]" />
                <h2 className="text-base font-bold text-[#0D1B2A]">Supporting Documents</h2>
              </div>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
                {org.documents.map((doc, i) => (
                  <a key={i} href={doc.url} className="flex items-center gap-3 p-3 bg-gray-50 rounded-lg hover:bg-gray-100 transition-colors">
                    <FileText size={18} className="text-[#D4AF37] shrink-0" />
                    <div className="min-w-0">
                      <p className="text-sm text-gray-700 truncate">{doc.name}</p>
                      <p className="text-xs text-gray-400">{doc.type}</p>
                    </div>
                  </a>
                ))}
              </div>
            </div>
          )}

          {/* Organization Users (Section 6.16) */}
          {org && (
            <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
              <div className="flex items-center justify-between mb-4">
                <div className="flex items-center gap-2">
                  <Users size={18} className="text-[#D4AF37]" />
                  <h2 className="text-base font-bold text-[#0D1B2A]">Staff Members</h2>
                </div>
                <span className="text-xs text-gray-500">{org.users.length} users</span>
              </div>
              <div className="overflow-x-auto">
                <table className="w-full text-left text-sm">
                  <thead className="border-b border-gray-100">
                    <tr>
                      <th className="py-2 pr-4 font-semibold text-gray-500 text-xs uppercase">Name</th>
                      <th className="py-2 pr-4 font-semibold text-gray-500 text-xs uppercase">Role</th>
                      <th className="py-2 pr-4 font-semibold text-gray-500 text-xs uppercase">Status</th>
                      <th className="py-2 font-semibold text-gray-500 text-xs uppercase text-right">Last Active</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-50">
                    {org.users.map((user) => (
                      <tr key={user.id}>
                        <td className="py-3 pr-4">
                          <p className="font-medium text-gray-800">{user.name}</p>
                          <p className="text-xs text-gray-500">{user.email}</p>
                        </td>
                        <td className="py-3 pr-4 text-gray-700 text-xs">
                          {user.role.replace(/_/g, ' ')}
                        </td>
                        <td className="py-3 pr-4">
                          <span className={cn(
                            "inline-block px-2 py-0.5 rounded text-xs font-medium",
                            user.status === 'ACTIVE' 
                              ? "bg-green-50 text-green-700" 
                              : "bg-red-50 text-red-700"
                          )}>
                            {user.status}
                          </span>
                        </td>
                        <td className="py-3 text-gray-500 text-xs text-right">{user.lastActive}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          )}
        </div>

        {/* RIGHT COLUMN */}
        <div className="space-y-6">

          {/* Verification Decision Panel (Section 6.15) */}
          {baseOrg.verificationStatus === 'PENDING_VERIFICATION' && (
            <div className="bg-white p-6 rounded-xl border-2 border-[#D4AF37] shadow-lg sticky top-6">
              <h2 className="text-base font-bold text-[#0D1B2A] mb-1">Verification Decision</h2>
              <p className="text-xs text-gray-500 mb-4">
                This action will be recorded in the audit log.
              </p>

              {reviewMode === 'none' ? (
                <div className="space-y-2">
                  <button
                    onClick={handleVerify}
                    disabled={isSubmitting}
                    className="w-full flex items-center justify-center gap-2 bg-green-600 hover:bg-green-700 text-white py-2.5 rounded-lg text-sm font-semibold transition-colors disabled:opacity-50"
                  >
                    <ShieldCheck size={16} />
                    Verify Organization
                  </button>
                  <button
                    onClick={() => setReviewMode('info')}
                    className="w-full flex items-center justify-center gap-2 bg-yellow-500 hover:bg-yellow-600 text-white py-2.5 rounded-lg text-sm font-semibold transition-colors"
                  >
                    <AlertCircle size={16} />
                    Request More Info
                  </button>
                  <button
                    onClick={() => setReviewMode('reject')}
                    className="w-full flex items-center justify-center gap-2 bg-red-600 hover:bg-red-700 text-white py-2.5 rounded-lg text-sm font-semibold transition-colors"
                  >
                    <ShieldAlert size={16} />
                    Reject
                  </button>
                </div>
              ) : (
                <div className="space-y-4">
                  <div>
                    <label className="block text-xs font-semibold text-gray-700 mb-2">
                      {reviewMode === 'reject' ? 'Reason for Rejection (Required)' : 'Information Required (Required)'}
                    </label>
                    <textarea
                      value={reason}
                      onChange={(e) => setReason(e.target.value)}
                      rows={5}
                      placeholder="Provide a detailed reason. This will be sent to the organization."
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

          {/* Quick Info */}
          <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
            <h2 className="text-base font-bold text-[#0D1B2A] mb-4">Quick Info</h2>
            <div className="space-y-3 text-sm">
              <InfoRow label="Staff Count" value={baseOrg.staffCount.toString()} />
              <InfoRow label="Areas" value={baseOrg.areasOfOperation.length.toString()} />
              {org && <InfoRow label="Year Established" value={org.yearEstablished} />}
              {org && <InfoRow label="Active Users" value={org.users.filter(u => u.status === 'ACTIVE').length.toString()} />}
            </div>
          </div>

          {/* Audit Trail */}
          {org && (
            <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
              <div className="flex items-center gap-2 mb-4">
                <Clock size={18} className="text-[#D4AF37]" />
                <h2 className="text-base font-bold text-[#0D1B2A]">Audit Trail</h2>
              </div>
              <div className="space-y-4">
                {org.auditTrail.map((entry, i) => (
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
          )}
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
      <div className="p-2 bg-gray-50 rounded-md shrink-0">
        <Icon size={16} className="text-[#D4AF37]" />
      </div>
      <div className="min-w-0">
        <p className="text-xs text-gray-400 uppercase font-semibold">{label}</p>
       <p className="text-sm text-gray-800 font-medium mt-0.5 wrap-break-word">{value}</p>
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