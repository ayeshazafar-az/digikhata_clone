-- Supabase RLS Policies for Digikhata Admin Panel
-- Provide these commands into your Supabase SQL snippet editor to activate the live Admin Panel 
-- and eliminate the mock fallback data.

-- 1. PROFILES: Super Admins can manage all profiles
CREATE POLICY "Super Admins can view all profiles" 
ON profiles 
FOR SELECT 
TO authenticated 
USING (
  (SELECT role FROM profiles WHERE id = auth.uid()) = 'super_admin' OR id = auth.uid()
);

CREATE POLICY "Super Admins can update all profiles" 
ON profiles 
FOR UPDATE 
TO authenticated 
USING (
  (SELECT role FROM profiles WHERE id = auth.uid()) = 'super_admin'
);


-- 2. BUSINESSES: Super Admins can view all businesses
CREATE POLICY "Super Admins can view all businesses" 
ON businesses 
FOR SELECT 
TO authenticated 
USING (
  (SELECT role FROM profiles WHERE id = auth.uid()) = 'super_admin' OR owner_id = auth.uid()
);

CREATE POLICY "Super Admins can update all businesses" 
ON businesses 
FOR UPDATE 
TO authenticated 
USING (
  (SELECT role FROM profiles WHERE id = auth.uid()) = 'super_admin'
);

-- 3. FAQS: System wide configurations
CREATE TABLE IF NOT EXISTS faqs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  category TEXT NOT NULL,
  question TEXT NOT NULL,
  answer TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Allow anyone reading FAQs
CREATE POLICY "Public read access for FAQs"
ON faqs FOR SELECT TO public USING (true);

-- Allow super admins to manipulate FAQs
CREATE POLICY "Admins can manage FAQs"
ON faqs FOR ALL TO authenticated USING (
  (SELECT role FROM profiles WHERE id = auth.uid()) = 'super_admin'
);