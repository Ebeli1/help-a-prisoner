'use client';

import { useState } from 'react';
import { useParams } from 'next/navigation';
import Link from 'next/link';
import { 
  ArrowLeft, FileText, User, Clock, 
  RefreshCcw, RotateCcw, AlertCircle, Mail, Phone,
  CreditCard, Hash, Building2, Lock, LucideIcon
} from 'lucide-react';
import { cn } from '@/lib/utils';
import { mockDonationDetails, mockDonations, DonationStatus, PaymentProvider } from '@/lib/mockData';

const getStatusStyle = (status: DonationStatus) => {
  switch (status) {
    case 'SUCCESSFUL': return 'bg-green-100 text-green-700 border-green-200';
    case 'PENDING': return 'bg-yellow-100 text-yellow-700 border-yellow-200';
    case 'FAILED': return 'bg-red-100 text-red-700 border-red-200';
    case 'REFUNDED': return 'bg-orange-100 text-orange-700 border-orange-200';
    case 'REVERSED': return 'bg-purple-100 text-purple-700 border-purple-200';
    default: return 'bg-gray-100 text-gray-700';
  }
};

const getProviderLabel = (provider: PaymentProvider) => {
  switch (provider) {
    case 'PAYSTACK': return 'Paystack';
    case 'FLUTTERWAVE': return 'Flutterwave';
    case 'BANK_TRANSFER': return 'Bank Transfer';
  }
};

export default function DonationDetailsPage() {
  const params = useParams();
  const donationId = params.id as string;

  const [correctionMode, setCorrectionMode] = useState<'none' | 'refund' | 'reversal' | 'correction'>('none');
  const [amount, setAmount] = useState('');
  const [reason, setReason] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);

  // Fallback to list data
  const baseDonation = mockDonations.find(d => d.id === donationId);
  const donation = mockDonationDetails?.[donationId];

  if (!baseDonation) {
    return (
      <div className="text-center py-20">
        <AlertCircle size={48} className="mx-auto text-gray-300" />
        <h2 className="mt-4 text-lg font-semibold text-gray-700">Donation Not Found</h2>
        <p className="text-sm text-gray-500 mt-1">The donation ID {donationId} does not exist.</p>
        <Link href="/dashboard/donations" className="mt-6 inline-block text-sm text-[#D4AF37] hover:underline">
          ← Back to Donations
        </Link>
      </div>
    );
  }

  const handleSubmitCorrection = () => {
    if (!reason.trim()) return;
    if ((correctionMode === 'correction' || correctionMode === 'refund') && !amount.trim()) return;
    setIsSubmitting(true);
    setTimeout(() => {
      setIsSubmitting(false);
      setCorrectionMode('none');
      setAmount('');
      setReason('');
    }, 1000);
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center gap-3">
        <Link 
          href="/dashboard/donations"
          className="p-2 text-gray-500 hover:bg-gray-100 rounded-md"
        >
          <ArrowLeft size={20} />
        </Link>
        <div>
          <p className="text-xs font-mono text-gray-400">{baseDonation.id}</p>
          <h1 className="text-xl font-bold text-[#0D1B2A]">
            ₦{baseDonation.amount.toLocaleString()} Donation
          </h1>
        </div>
        <span className={cn(
          "ml-auto inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold border",
          getStatusStyle(baseDonation.status)
        )}>
          {baseDonation.status}
        </span>
      </div>

      {/* Immutability Warning */}
      <div className="bg-blue-50 border border-blue-200 rounded-xl p-4 flex items-start gap-3">
        <Lock size={18} className="text-blue-600 shrink-0 mt-0.5" />
        <div>
          <p className="text-sm font-semibold text-blue-900">Immutable Transaction Record</p>
          <p className="text-xs text-blue-700 mt-1">
            This record cannot be edited. To correct an amount, issue a refund, or reverse a transaction, use the actions in the panel on the right. Every action creates a new record for the audit trail.
          </p>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* LEFT COLUMN */}
        <div className="lg:col-span-2 space-y-6">
          
          {/* Transaction Details */}
          <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
            <h2 className="text-base font-bold text-[#0D1B2A] mb-4">Transaction Details</h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <DetailRow icon={CreditCard} label="Amount" value={`₦${baseDonation.amount.toLocaleString()}`} />
              <DetailRow icon={Hash} label="Transaction Reference" value={baseDonation.transactionReference} />
              <DetailRow icon={Building2} label="Payment Provider" value={getProviderLabel(baseDonation.paymentProvider)} />
              <DetailRow icon={Clock} label="Date & Time" value={baseDonation.date} />
            </div>
          </div>

          {/* Campaign */}
          <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
            <h2 className="text-base font-bold text-[#0D1B2A] mb-4">Destination</h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <DetailRow icon={FileText} label="Campaign" value={baseDonation.campaign} />
              <DetailRow icon={Building2} label="Organization" value={baseDonation.organization} />
            </div>
            <Link 
              href={`/dashboard/campaigns/${baseDonation.campaignId}`}
              className="mt-4 inline-flex items-center gap-1 text-xs font-semibold text-[#D4AF37] hover:underline"
            >
              View Campaign →
            </Link>
          </div>

          {/* Donor Info */}
          <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
            <h2 className="text-base font-bold text-[#0D1B2A] mb-4">Donor Information</h2>
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <DetailRow icon={User} label="Donor" value={baseDonation.donor} />
              <DetailRow icon={Mail} label="Email" value={baseDonation.donorEmail} />
              {donation?.donorPhone && <DetailRow icon={Phone} label="Phone" value={donation.donorPhone} />}
            </div>
            {donation?.donorNote && (
              <div className="mt-4 pt-4 border-t border-gray-100">
                <p className="text-xs text-gray-500 mb-1">Donor Note</p>
                <p className="text-sm text-gray-700 italic">&ldquo;{donation.donorNote}&rdquo;</p>
              </div>
            )}
          </div>

          {/* Corrections History */}
          {donation && donation.corrections.length > 0 && (
            <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
              <h2 className="text-base font-bold text-[#0D1B2A] mb-4">Correction History</h2>
              <div className="space-y-3">
                {donation.corrections.map((correction) => (
                  <div key={correction.id} className="flex items-start gap-3 p-3 bg-gray-50 rounded-lg">
                    <div className={cn(
                      "p-2 rounded-md shrink-0",
                      correction.type === 'REFUND' ? 'bg-orange-100 text-orange-600' :
                      correction.type === 'REVERSAL' ? 'bg-purple-100 text-purple-600' :
                      'bg-blue-100 text-blue-600'
                    )}>
                      {correction.type === 'REFUND' && <RefreshCcw size={14} />}
                      {correction.type === 'REVERSAL' && <RotateCcw size={14} />}
                      {correction.type === 'CORRECTION' && <AlertCircle size={14} />}
                    </div>
                    <div className="flex-1">
                      <div className="flex items-center justify-between gap-3 flex-wrap">
                        <p className="text-sm font-semibold text-gray-800">
                          {correction.type} — ₦{correction.amount.toLocaleString()}
                        </p>
                        <p className="text-xs text-gray-400">{correction.date}</p>
                      </div>
                      <p className="text-xs text-gray-600 mt-1">{correction.reason}</p>
                      <p className="text-xs text-gray-400 mt-1">by {correction.actor}</p>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>

        {/* RIGHT COLUMN */}
        <div className="space-y-6">

          {/* Correction Actions Panel */}
          {baseDonation.status === 'SUCCESSFUL' && (
            <div className="bg-white p-6 rounded-xl border-2 border-[#D4AF37] shadow-lg sticky top-6">
              <h2 className="text-base font-bold text-[#0D1B2A] mb-1">Correction Actions</h2>
              <p className="text-xs text-gray-500 mb-4">
                These actions create new immutable records.
              </p>

              {correctionMode === 'none' ? (
                <div className="space-y-2">
                  <button
                    onClick={() => setCorrectionMode('refund')}
                    className="w-full flex items-center justify-center gap-2 bg-orange-600 hover:bg-orange-700 text-white py-2.5 rounded-lg text-sm font-semibold transition-colors"
                  >
                    <RefreshCcw size={16} />
                    Issue Refund
                  </button>
                  <button
                    onClick={() => setCorrectionMode('reversal')}
                    className="w-full flex items-center justify-center gap-2 bg-purple-600 hover:bg-purple-700 text-white py-2.5 rounded-lg text-sm font-semibold transition-colors"
                  >
                    <RotateCcw size={16} />
                    Reverse Transaction
                  </button>
                  <button
                    onClick={() => setCorrectionMode('correction')}
                    className="w-full flex items-center justify-center gap-2 bg-blue-600 hover:bg-blue-700 text-white py-2.5 rounded-lg text-sm font-semibold transition-colors"
                  >
                    <AlertCircle size={16} />
                    Add Correction
                  </button>
                </div>
              ) : (
                <div className="space-y-4">
                  {correctionMode !== 'reversal' && (
                    <div>
                      <label className="block text-xs font-semibold text-gray-700 mb-2">
                        Amount (₦) <span className="text-red-500">*</span>
                      </label>
                      <input
                        type="number"
                        value={amount}
                        onChange={(e) => setAmount(e.target.value)}
                        placeholder="0"
                        className="w-full text-sm border border-gray-300 rounded-lg p-3 outline-none focus:border-[#D4AF37]"
                      />
                    </div>
                  )}
                  <div>
                    <label className="block text-xs font-semibold text-gray-700 mb-2">
                      Reason <span className="text-red-500">*</span>
                    </label>
                    <textarea
                      value={reason}
                      onChange={(e) => setReason(e.target.value)}
                      rows={4}
                      placeholder="Provide a detailed reason. This is recorded permanently."
                      className="w-full text-sm border border-gray-300 rounded-lg p-3 outline-none focus:border-[#D4AF37] resize-none"
                    />
                  </div>
                  <div className="flex gap-2">
                    <button
                      onClick={() => { setCorrectionMode('none'); setAmount(''); setReason(''); }}
                      className="flex-1 py-2 text-sm font-medium text-gray-600 border border-gray-200 rounded-lg hover:bg-gray-50"
                    >
                      Cancel
                    </button>
                    <button
                      onClick={handleSubmitCorrection}
                      disabled={!reason.trim() || (correctionMode !== 'reversal' && !amount.trim()) || isSubmitting}
                      className={cn(
                        "flex-1 py-2 text-sm font-semibold text-white rounded-lg disabled:opacity-50",
                        correctionMode === 'refund' ? "bg-orange-600 hover:bg-orange-700" :
                        correctionMode === 'reversal' ? "bg-purple-600 hover:bg-purple-700" :
                        "bg-blue-600 hover:bg-blue-700"
                      )}
                    >
                      {isSubmitting ? 'Submitting...' : 'Submit'}
                    </button>
                  </div>
                </div>
              )}
            </div>
          )}

          {/* Audit Trail */}
          {donation && (
            <div className="bg-white p-6 rounded-xl border border-gray-200 shadow-sm">
              <div className="flex items-center gap-2 mb-4">
                <Clock size={18} className="text-[#D4AF37]" />
                <h2 className="text-base font-bold text-[#0D1B2A]">Audit Trail</h2>
              </div>
              <div className="space-y-4">
                {donation.auditTrail.map((entry, i) => (
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