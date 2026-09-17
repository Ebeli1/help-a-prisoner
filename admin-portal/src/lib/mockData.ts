import { CampaignStatus, ProjectStatus } from './types';

// ==========================================
// SECTION 1: Campaigns List
// ==========================================
export interface Campaign {
  id: string;
  title: string;
  category: string;
  organization: string;
  target: number;
  raised: number;
  status: CampaignStatus;
  dateCreated: string;
}

export const mockCampaigns: Campaign[] = [
  { id: 'CMP-001', title: 'Digital Skills Training Centre', category: 'Education', organization: 'Dominion City Prisons Ministry', target: 4000000, raised: 2400000, status: 'ACTIVE', dateCreated: '2026-08-15' },
  { id: 'CMP-002', title: 'Prison Library Restoration', category: 'Infrastructure', organization: 'Golden Heart Foundation', target: 2000000, raised: 2000000, status: 'FUNDED', dateCreated: '2026-07-22' },
  { id: 'CMP-003', title: 'Vocational Training Equipment', category: 'Vocational', organization: 'Discipleship Leadership Institution', target: 1000000, raised: 650000, status: 'ACTIVE', dateCreated: '2026-09-01' },
  { id: 'CMP-004', title: 'Reintegration Support Program', category: 'Rehabilitation', organization: 'Dominion City Prisons Ministry', target: 3000000, raised: 0, status: 'PENDING_REVIEW', dateCreated: '2026-09-10' },
  { id: 'CMP-005', title: 'Medical Outreach Program', category: 'Healthcare', organization: 'Golden Heart Foundation', target: 1500000, raised: 0, status: 'PENDING_REVIEW', dateCreated: '2026-09-12' },
  { id: 'CMP-006', title: 'Prison Sports Facility Upgrade', category: 'Infrastructure', organization: 'Discipleship Leadership Institution', target: 2500000, raised: 0, status: 'DRAFT', dateCreated: '2026-09-14' },
  { id: 'CMP-007', title: 'Post-Release Mentorship Program', category: 'Rehabilitation', organization: 'Dominion City Prisons Ministry', target: 800000, raised: 800000, status: 'COMPLETED', dateCreated: '2026-05-01' },
  { id: 'CMP-008', title: 'Adult Literacy Classes', category: 'Education', organization: 'Golden Heart Foundation', target: 500000, raised: 120000, status: 'SUSPENDED', dateCreated: '2026-06-15' },
];

// ==========================================
// SECTION 2: Full Campaign Details
// ==========================================
export interface CampaignDetails extends Campaign {
  description: string;
  useOfFunds: { item: string; amount: number }[];
  expectedOutcome: string;
  projectName: string;
  facilityName: string;
  supportingDocs: { name: string; url: string }[];
  photos: string[];
  verificationInfo: {
    submittedBy: string;
    submittedDate: string;
    verifiedByOrg: string;
    contactPerson: string;
    contactEmail: string;
  };
  auditTrail: {
    date: string;
    actor: string;
    action: string;
    note?: string;
  }[];
}

export const mockCampaignDetails: Record<string, CampaignDetails> = {
  'CMP-004': {
    id: 'CMP-004',
    title: 'Reintegration Support Program',
    category: 'Rehabilitation',
    organization: 'Dominion City Prisons Ministry',
    target: 3000000,
    raised: 0,
    status: 'PENDING_REVIEW',
    dateCreated: '2026-09-10',
    projectName: 'Post-Release Reintegration Initiative',
    facilityName: 'Rivers State Prison - Facility A',
    description: 'This program aims to support 100 ex-offenders over 12 months with housing assistance, job placement, and psychological support to reduce recidivism in Rivers State.',
    useOfFunds: [
      { item: 'Housing stipends (₦20,000 x 100 beneficiaries x 3 months)', amount: 1800000 },
      { item: 'Job placement coordination and training', amount: 600000 },
      { item: 'Psychological counseling sessions', amount: 400000 },
      { item: 'Administrative and logistics', amount: 200000 },
    ],
    expectedOutcome: '70% of participants successfully reintegrated with stable employment within 6 months of release.',
    supportingDocs: [
      { name: 'Program Proposal.pdf', url: '#' },
      { name: 'Beneficiary Criteria.pdf', url: '#' },
      { name: 'Organization Registration.pdf', url: '#' },
    ],
    photos: [
      'https://images.unsplash.com/photo-1521791136064-7986c2920216?w=400',
      'https://images.unsplash.com/photo-1593113646773-028c64a8f1b8?w=400',
    ],
    verificationInfo: {
      submittedBy: 'Jane Smith',
      submittedDate: '2026-09-10',
      verifiedByOrg: 'Golden Heart Foundation',
      contactPerson: 'Jane Smith',
      contactEmail: 'jane@dominioncity.org',
    },
    auditTrail: [
      { date: '2026-09-10 09:30', actor: 'Jane Smith', action: 'CAMPAIGN_CREATED', note: 'Initial draft created.' },
      { date: '2026-09-10 14:15', actor: 'Jane Smith', action: 'CAMPAIGN_SUBMITTED', note: 'Submitted for review.' },
    ],
  },
};

// ==========================================
// SECTION 3: Projects List
// ==========================================
export interface Project {
  id: string;
  name: string;
  organization: string;
  facilityName: string;
  target: number;
  raised: number;
  fundingStatus: 'UNFUNDED' | 'PARTIALLY_FUNDED' | 'FUNDED';
  implementationStatus: ProjectStatus;
  progress: number;
  startDate: string;
  expectedCompletion: string;
}

export const mockProjects: Project[] = [
  { id: 'PRJ-001', name: 'Digital Skills Centre', organization: 'Dominion City Prisons Ministry', facilityName: 'Rivers State Prison - Facility A', target: 4000000, raised: 4000000, fundingStatus: 'FUNDED', implementationStatus: 'IMPLEMENTATION', progress: 75, startDate: '2026-06-01', expectedCompletion: '2026-12-15' },
  { id: 'PRJ-002', name: 'Prison Library Restoration', organization: 'Golden Heart Foundation', facilityName: 'Lagos Central Prison', target: 2000000, raised: 2000000, fundingStatus: 'FUNDED', implementationStatus: 'COMPLETED', progress: 100, startDate: '2026-03-01', expectedCompletion: '2026-08-30' },
  { id: 'PRJ-003', name: 'Vocational Training Workshop', organization: 'Discipleship Leadership Institution', facilityName: 'Abuja Medium Security Prison', target: 1000000, raised: 650000, fundingStatus: 'PARTIALLY_FUNDED', implementationStatus: 'FUNDRAISING', progress: 0, startDate: '2026-10-01', expectedCompletion: '2027-03-30' },
  { id: 'PRJ-004', name: 'Post-Release Housing Initiative', organization: 'Dominion City Prisons Ministry', facilityName: 'Rivers State Prison - Facility B', target: 5000000, raised: 0, fundingStatus: 'UNFUNDED', implementationStatus: 'UNDER_REVIEW', progress: 0, startDate: 'TBD', expectedCompletion: 'TBD' },
  { id: 'PRJ-005', name: 'Prison Sports Complex', organization: 'Golden Heart Foundation', facilityName: 'Kano Central Prison', target: 8000000, raised: 0, fundingStatus: 'UNFUNDED', implementationStatus: 'PROPOSED', progress: 0, startDate: 'TBD', expectedCompletion: 'TBD' },
];

// ==========================================
// SECTION 4: Full Project Details
// ==========================================
export interface ProjectDetails extends Project {
  purpose: string;
  projectOwner: string;
  updates: {
    date: string;
    update: string;
    status: 'PENDING' | 'APPROVED';
  }[];
  impact?: {
    participants: number;
    trainingSessions: number;
    outcome?: string;
  };
}

export const mockProjectDetails: Record<string, ProjectDetails> = {
  'PRJ-001': {
    id: 'PRJ-001',
    name: 'Digital Skills Centre',
    organization: 'Dominion City Prisons Ministry',
    facilityName: 'Rivers State Prison - Facility A',
    target: 4000000,
    raised: 4000000,
    fundingStatus: 'FUNDED',
    implementationStatus: 'IMPLEMENTATION',
    progress: 75,
    startDate: '2026-06-01',
    expectedCompletion: '2026-12-15',
    purpose: 'Establish a fully equipped digital skills training centre for inmates and recently released individuals, teaching web development, graphic design, and data entry.',
    projectOwner: 'Jane Smith',
    updates: [
      { date: '2026-08-15', update: 'Equipment delivered and inspected.', status: 'APPROVED' },
      { date: '2026-08-05', update: 'Installation of computers started.', status: 'APPROVED' },
      { date: '2026-07-20', update: 'Facility renovation completed.', status: 'APPROVED' },
    ],
    impact: {
      participants: 50,
      trainingSessions: 20,
      outcome: 'Ongoing - first cohort in progress.',
    },
  },
};

// ==========================================
// SECTION 5: Organizations
// ==========================================
export type VerificationStatus = 'PENDING_VERIFICATION' | 'VERIFIED' | 'REJECTED' | 'MORE_INFO_REQUESTED';

export interface Organization {
  id: string;
  name: string;
  logo: string | null;
  description: string;
  contactEmail: string;
  contactPhone: string;
  areasOfOperation: string[];
  verificationStatus: VerificationStatus;
  dateRegistered: string;
  staffCount: number;
}

export const mockOrganizations: Organization[] = [
  {
    id: 'ORG-001',
    name: 'Dominion City Prisons Ministry',
    logo: null,
    description: 'A faith-based ministry dedicated to the spiritual, emotional, and practical rehabilitation of incarcerated individuals across Nigeria.',
    contactEmail: 'info@dominioncity.org',
    contactPhone: '+234 801 234 5678',
    areasOfOperation: ['Rivers State', 'Lagos', 'Abuja'],
    verificationStatus: 'VERIFIED',
    dateRegistered: '2024-01-15',
    staffCount: 12,
  },
  {
    id: 'ORG-002',
    name: 'Golden Heart Foundation',
    logo: null,
    description: 'A humanitarian organization focused on providing educational opportunities and skill acquisition for prison inmates.',
    contactEmail: 'contact@goldenheart.org',
    contactPhone: '+234 802 345 6789',
    areasOfOperation: ['Lagos', 'Ogun State'],
    verificationStatus: 'VERIFIED',
    dateRegistered: '2024-03-22',
    staffCount: 8,
  },
  {
    id: 'ORG-003',
    name: 'Discipleship Leadership Institution',
    logo: null,
    description: 'Training and mentorship organization providing vocational skills and leadership development for prison inmates.',
    contactEmail: 'hello@dli.org',
    contactPhone: '+234 803 456 7890',
    areasOfOperation: ['Abuja', 'Kano'],
    verificationStatus: 'VERIFIED',
    dateRegistered: '2024-05-10',
    staffCount: 6,
  },
  {
    id: 'ORG-004',
    name: 'Hope Rebuilders Initiative',
    logo: null,
    description: 'A new organization seeking to support post-release housing and job placement for ex-offenders.',
    contactEmail: 'contact@hoperebuilders.ng',
    contactPhone: '+234 804 567 8901',
    areasOfOperation: ['Rivers State'],
    verificationStatus: 'PENDING_VERIFICATION',
    dateRegistered: '2026-09-05',
    staffCount: 3,
  },
  {
    id: 'ORG-005',
    name: 'Restoration Alliance',
    logo: null,
    description: 'Providing medical outreach and mental health support to inmates.',
    contactEmail: 'info@restorationalliance.org',
    contactPhone: '+234 805 678 9012',
    areasOfOperation: ['Enugu', 'Anambra'],
    verificationStatus: 'MORE_INFO_REQUESTED',
    dateRegistered: '2026-08-20',
    staffCount: 4,
  },
  {
    id: 'ORG-006',
    name: 'Unverified Front Co.',
    logo: null,
    description: 'Organization that failed verification due to missing legal documents.',
    contactEmail: 'suspicious@example.com',
    contactPhone: '+234 806 789 0123',
    areasOfOperation: ['Unknown'],
    verificationStatus: 'REJECTED',
    dateRegistered: '2026-07-12',
    staffCount: 1,
  },
];

// ==========================================
// SECTION 6: Full Organization Details
// ==========================================
export interface OrganizationUser {
  id: string;
  name: string;
  email: string;
  role: 'ORGANIZATION_ADMIN' | 'PROJECT_OFFICER' | 'FINANCE_OFFICER' | 'FIELD_OFFICER';
  status: 'ACTIVE' | 'SUSPENDED';
  lastActive: string;
}

export interface OrganizationDetails extends Organization {
  registrationNumber: string;
  yearEstablished: string;
  website: string;
  address: string;
  authorizedRepresentative: {
    name: string;
    title: string;
    email: string;
    phone: string;
  };
  documents: {
    name: string;
    type: 'REGISTRATION' | 'LICENSE' | 'ID' | 'OTHER';
    url: string;
  }[];
  users: OrganizationUser[];
  auditTrail: {
    date: string;
    actor: string;
    action: string;
    note?: string;
  }[];
}

export const mockOrganizationDetails: Record<string, OrganizationDetails> = {
  'ORG-004': {
    id: 'ORG-004',
    name: 'Hope Rebuilders Initiative',
    logo: null,
    description: 'A new organization seeking to support post-release housing and job placement for ex-offenders.',
    contactEmail: 'contact@hoperebuilders.ng',
    contactPhone: '+234 804 567 8901',
    areasOfOperation: ['Rivers State'],
    verificationStatus: 'PENDING_VERIFICATION',
    dateRegistered: '2026-09-05',
    staffCount: 3,
    registrationNumber: 'RC-1827364',
    yearEstablished: '2025',
    website: 'https://hoperebuilders.ng',
    address: '12 Aba Road, Port Harcourt, Rivers State',
    authorizedRepresentative: {
      name: 'Michael Okonkwo',
      title: 'Executive Director',
      email: 'michael@hoperebuilders.ng',
      phone: '+234 804 567 8901',
    },
    documents: [
      { name: 'CAC Registration Certificate.pdf', type: 'REGISTRATION', url: '#' },
      { name: 'Tax Clearance Certificate.pdf', type: 'LICENSE', url: '#' },
      { name: 'Executive Director ID.pdf', type: 'ID', url: '#' },
      { name: 'Operational License.pdf', type: 'LICENSE', url: '#' },
    ],
    users: [
      { id: 'U-1', name: 'Michael Okonkwo', email: 'michael@hoperebuilders.ng', role: 'ORGANIZATION_ADMIN', status: 'ACTIVE', lastActive: '2 hours ago' },
      { id: 'U-2', name: 'Blessing Adeyemi', email: 'blessing@hoperebuilders.ng', role: 'PROJECT_OFFICER', status: 'ACTIVE', lastActive: '1 day ago' },
      { id: 'U-3', name: 'Emeka Nwosu', email: 'emeka@hoperebuilders.ng', role: 'FIELD_OFFICER', status: 'ACTIVE', lastActive: '3 days ago' },
    ],
    auditTrail: [
      { date: '2026-09-05 10:15', actor: 'Michael Okonkwo', action: 'ORGANIZATION_REGISTERED' },
      { date: '2026-09-05 10:20', actor: 'Michael Okonkwo', action: 'DOCUMENTS_UPLOADED', note: 'Uploaded 4 documents for review.' },
    ],
  },
};