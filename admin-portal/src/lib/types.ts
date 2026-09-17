export type UserRole = 
  | 'SUPER_ADMIN' 
  | 'ADMIN' 
  | 'ORGANIZATION_ADMIN' 
  | 'FIELD_OFFICER' 
  | 'SUPPORTER' 
  | 'VOLUNTEER';

export type CampaignStatus = 
  | 'DRAFT' 
  | 'PENDING_REVIEW' 
  | 'APPROVED' 
  | 'ACTIVE' 
  | 'FUNDED' 
  | 'COMPLETED' 
  | 'REJECTED' 
  | 'SUSPENDED';

export type ProjectStatus = 
  | 'PROPOSED' 
  | 'UNDER_REVIEW' 
  | 'APPROVED' 
  | 'FUNDRAISING' 
  | 'FUNDED' 
  | 'IMPLEMENTATION' 
  | 'COMPLETED' 
  | 'IMPACT_REPORTED';

export interface User {
  id: string;
  name: string;
  email: string;
  role: UserRole;
  organizationId?: string; // If tied to an organization
  status: 'ACTIVE' | 'SUSPENDED';
}
export type OrganizationStatus = 
  | 'PENDING_VERIFICATION' 
  | 'VERIFIED' 
  | 'REJECTED' 
  | 'MORE_INFO_REQUESTED';