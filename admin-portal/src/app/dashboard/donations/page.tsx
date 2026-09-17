'use client';

import { useState } from 'react';
import Link from 'next/link';
import { 
  Search, Eye, Download, TrendingUp, AlertCircle,
  CheckCircle2, Clock, XCircle, RefreshCcw, RotateCcw, Filter,
  LucideIcon
} from 'lucide-react';
import { cn } from '@/lib/utils';
import { mockDonations, DonationStatus, PaymentProvider } from '@/lib/mockData';

const statusFilters: { label: string; value: DonationStatus | 'ALL' }[] = [
  { label: 'All', value: 'ALL' },
  { label: 'Successful', value: 'SUCCESSFUL' },
  { label: 'Pending', value: 'PENDING' },
  { label: 'Failed', value: 'FAILED' },
  { label: 'Refunded', value: 'REFUNDED' },
  { label: 'Reversed', value: 'REVERSED' },
];

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

const getStatusIcon = (status: DonationStatus) => {
  switch (status) {
    case 'SUCCESSFUL': return CheckCircle2;
    case 'PENDING': return Clock;
    case 'FAILED': return XCircle;
    case 'REFUNDED': return RefreshCcw;
    case 'REVERSED': return RotateCcw;
    default: return CheckCircle2;
  }
};

const getProviderLabel = (provider: PaymentProvider) => {
  switch (provider) {
    case 'PAYSTACK': return 'Paystack';
    case 'FLUTTERWAVE': return 'Flutterwave';
    case 'BANK_TRANSFER': return 'Bank Transfer';
  }
};

// CSV Export utility
function exportDonationsCSV(donations: typeof mockDonations) {
  const headers = [
    'Donation ID', 'Date', 'Campaign', 'Organization', 'Donor', 'Donor Email',
    'Amount', 'Payment Provider', 'Transaction Reference', 'Status'
  ];
  const rows = donations.map(d => [
    d.id, d.date, d.campaign, d.organization, d.donor, d.donorEmail,
    d.amount, getProviderLabel(d.paymentProvider), d.transactionReference, d.status
  ]);
  const csvContent = [headers, ...rows]
    .map(row => row.map(field => `"${String(field).replace(/"/g, '""')}"`).join(','))
    .join('\n');

  const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' });
  const link = document.createElement('a');
  link.href = URL.createObjectURL(blob);
  link.download = `donations-report-${new Date().toISOString().split('T')[0]}.csv`;
  link.click();
}

export default function DonationsPage() {
  const [activeFilter, setActiveFilter] = useState<DonationStatus | 'ALL'>('ALL');
  const [searchQuery, setSearchQuery] = useState('');

  const filteredDonations = mockDonations.filter((donation) => {
    const matchesFilter = activeFilter === 'ALL' || donation.status === activeFilter;
    const matchesSearch = donation.id.toLowerCase().includes(searchQuery.toLowerCase()) ||
                          donation.campaign.toLowerCase().includes(searchQuery.toLowerCase()) ||
                          donation.donor.toLowerCase().includes(searchQuery.toLowerCase()) ||
                          donation.transactionReference.toLowerCase().includes(searchQuery.toLowerCase());
    return matchesFilter && matchesSearch;
  });

  // Stats
  const successful = mockDonations.filter(d => d.status === 'SUCCESSFUL');
  const totalRaised = successful.reduce((sum, d) => sum + d.amount, 0);
  const thisMonth = successful
    .filter(d => d.date.startsWith('2026-09'))
    .reduce((sum, d) => sum + d.amount, 0);
  const avgDonation = successful.length > 0 ? totalRaised / successful.length : 0;

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex flex-col md:flex-row md:items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-[#0D1B2A]">Donations</h1>
          <p className="text-gray-500 mt-1 text-sm">
            Immutable transaction records. Corrections create new records.
          </p>
        </div>
        <button
          onClick={() => exportDonationsCSV(filteredDonations)}
          className="flex items-center justify-center gap-2 bg-[#0D1B2A] hover:bg-[#1B2A3A] text-white px-4 py-2 rounded-lg text-sm font-medium transition-colors"
        >
          <Download size={16} />
          Export CSV
        </button>
      </div>

      {/* Financial Overview (Section 6.4) */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        <StatCard
          label="Total Raised"
          value={`₦${(totalRaised / 1000000).toFixed(2)}M`}
          icon={TrendingUp}
          color="text-[#0D1B2A]"
        />
        <StatCard
          label="This Month"
          value={`₦${(thisMonth / 1000000).toFixed(2)}M`}
          icon={TrendingUp}
          color="text-green-600"
        />
        <StatCard
          label="Successful Donations"
          value={successful.length.toString()}
          icon={CheckCircle2}
          color="text-green-600"
        />
        <StatCard
          label="Average Donation"
          value={`₦${avgDonation.toLocaleString(undefined, { maximumFractionDigits: 0 })}`}
          icon={TrendingUp}
          color="text-[#D4AF37]"
        />
      </div>

      {/* Filters */}
      <div className="bg-white p-4 rounded-xl border border-gray-200 shadow-sm space-y-4">
        <div className="flex flex-col md:flex-row gap-3">
          <div className="flex-1 flex items-center bg-gray-50 border border-gray-200 rounded-lg px-3 py-2">
            <Search size={16} className="text-gray-400 shrink-0" />
            <input
              type="text"
              placeholder="Search by ID, campaign, donor, or transaction ref..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="bg-transparent border-none outline-none ml-2 text-sm w-full"
            />
          </div>
          <button className="flex items-center justify-center gap-2 px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-200 rounded-lg hover:bg-gray-50">
            <Filter size={16} />
            Date Range
          </button>
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

      {/* Donations Table */}
      <div className="bg-white rounded-xl border border-gray-200 shadow-sm overflow-hidden">
        <div className="overflow-x-auto">
          <table className="w-full text-left text-sm">
            <thead className="bg-gray-50 border-b border-gray-200">
              <tr>
                <th className="px-6 py-3 font-semibold text-gray-600 text-xs uppercase tracking-wider">ID</th>
                <th className="px-6 py-3 font-semibold text-gray-600 text-xs uppercase tracking-wider">Date</th>
                <th className="px-6 py-3 font-semibold text-gray-600 text-xs uppercase tracking-wider">Campaign / Donor</th>
                <th className="px-6 py-3 font-semibold text-gray-600 text-xs uppercase tracking-wider">Amount</th>
                <th className="px-6 py-3 font-semibold text-gray-600 text-xs uppercase tracking-wider">Provider</th>
                <th className="px-6 py-3 font-semibold text-gray-600 text-xs uppercase tracking-wider">Status</th>
                <th className="px-6 py-3 font-semibold text-gray-600 text-xs uppercase tracking-wider text-right">Actions</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-100">
              {filteredDonations.map((donation) => {
                const StatusIcon = getStatusIcon(donation.status);
                return (
                  <tr key={donation.id} className="hover:bg-gray-50/50 transition-colors">
                    <td className="px-6 py-4 font-mono text-xs text-gray-500">
                      {donation.id}
                    </td>
                    <td className="px-6 py-4 text-xs text-gray-600 whitespace-nowrap">
                      {donation.date}
                    </td>
                    <td className="px-6 py-4">
                      <div className="font-medium text-gray-900 text-sm">{donation.campaign}</div>
                      <div className="text-xs text-gray-500 mt-0.5">
                        {donation.donor === 'Anonymous' ? (
                          <span className="italic">Anonymous Donor</span>
                        ) : (
                          donation.donor
                        )}
                      </div>
                    </td>
                    <td className="px-6 py-4">
                      <span className="font-semibold text-[#0D1B2A]">
                        ₦{donation.amount.toLocaleString()}
                      </span>
                    </td>
                    <td className="px-6 py-4 text-xs text-gray-600">
                      {getProviderLabel(donation.paymentProvider)}
                    </td>
                    <td className="px-6 py-4">
                      <span className={cn(
                        "inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full text-xs font-medium border",
                        getStatusStyle(donation.status)
                      )}>
                        <StatusIcon size={12} />
                        {donation.status}
                      </span>
                    </td>
                    <td className="px-6 py-4 text-right">
                      <Link 
                        href={`/dashboard/donations/${donation.id}`}
                        className="inline-flex p-2 text-gray-400 hover:text-blue-600 hover:bg-blue-50 rounded-md transition-colors"
                        title="View Details"
                      >
                        <Eye size={16} />
                      </Link>
                    </td>
                  </tr>
                );
              })}
            </tbody>
          </table>
        </div>

        {filteredDonations.length === 0 && (
          <div className="text-center py-12">
            <AlertCircle size={40} className="mx-auto text-gray-300" />
            <p className="mt-3 text-sm font-medium text-gray-900">No donations found</p>
            <p className="text-xs text-gray-500 mt-1">Try changing the filter or search query.</p>
          </div>
        )}

        <div className="px-6 py-3 border-t border-gray-100 flex items-center justify-between text-xs text-gray-500">
          <span>Showing {filteredDonations.length} of {mockDonations.length} donations</span>
          <div className="flex gap-2">
            <button className="px-3 py-1 border border-gray-200 rounded-md hover:bg-gray-50 disabled:opacity-50" disabled>Previous</button>
            <button className="px-3 py-1 border border-gray-200 rounded-md hover:bg-gray-50 disabled:opacity-50" disabled>Next</button>
          </div>
        </div>
      </div>
    </div>
  );
}

function StatCard({ 
  label, 
  value, 
  icon: Icon, 
  color 
}: { 
  label: string; 
  value: string; 
  icon: LucideIcon; 
  color: string 
}) {
  return (
    <div className="bg-white p-5 rounded-xl border border-gray-100 shadow-sm flex items-start justify-between">
      <div>
        <p className="text-xs text-gray-500 font-medium">{label}</p>
        <p className={cn("text-2xl font-bold mt-2", color)}>{value}</p>
      </div>
      <div className="p-2 bg-gray-50 rounded-lg">
        <Icon size={20} className="text-[#D4AF37]" />
      </div>
    </div>
  );
}