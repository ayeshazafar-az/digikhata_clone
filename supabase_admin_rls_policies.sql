-- Supabase RLS Policies for Digikhata Admin Panel (FIXED FOR INFINITE RECURSION)
-- Provide these commands into your Supabase SQL snippet editor to update the live Admin Panel 

-- First, create a secure function that bypasses RLS to check for admin status
-- This prevents the "infinite recursion" error when querying the profiles table!
CREATE OR REPLACE FUNCTION public.is_super_admin()
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER
AS $$
  SELECT EXISTS(
    SELECT 1 FROM public.profiles WHERE id = auth.uid() AND role = 'super_admin'
  );
$$;

-- 1. PROFILES: Prevent infinite recursion by using the new function
DROP POLICY IF EXISTS "Super Admins can view all profiles" ON profiles;
CREATE POLICY "Super Admins can view all profiles" 
ON profiles 
FOR SELECT 
TO authenticated 
USING (
  is_super_admin() OR id = auth.uid()
);

DROP POLICY IF EXISTS "Super Admins can update all profiles" ON profiles;
CREATE POLICY "Super Admins can update all profiles" 
ON profiles 
FOR UPDATE 
TO authenticated 
USING (
  is_super_admin()
);


-- 2. BUSINESSES: Update this to use the safe function as well
DROP POLICY IF EXISTS "Super Admins can view all businesses" ON businesses;
CREATE POLICY "Super Admins can view all businesses" 
ON businesses 
FOR SELECT 
TO authenticated 
USING (
  is_super_admin() OR owner_id = auth.uid()
);

DROP POLICY IF EXISTS "Super Admins can update all businesses" ON businesses;
CREATE POLICY "Super Admins can update all businesses" 
ON businesses 
FOR UPDATE 
TO authenticated 
USING (
  is_super_admin()
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
DROP POLICY IF EXISTS "Public read access for FAQs" ON faqs;
CREATE POLICY "Public read access for FAQs"
ON faqs FOR SELECT TO public USING (true);

-- Allow super admins to manipulate FAQs
DROP POLICY IF EXISTS "Admins can manage FAQs" ON faqs;
CREATE POLICY "Admins can manage FAQs"
ON faqs FOR ALL TO authenticated USING (
  is_super_admin()
);