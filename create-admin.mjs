// Usage: ADMIN_PASSWORD='long-password' npm run admin:create -- "Full Name" email@example.com [super_admin|registration_admin|read_only_auditor]
import 'dotenv/config';import bcrypt from 'bcryptjs';import {createClient} from '@supabase/supabase-js';
const [name,email,role='super_admin']=process.argv.slice(2),pw=process.env.ADMIN_PASSWORD;
if(!name||!email||!pw||pw.length<12){console.error('Need name, email and ADMIN_PASSWORD (12+ chars).');process.exit(1)}
const db=createClient(process.env.NEXT_PUBLIC_SUPABASE_URL,process.env.SUPABASE_SERVICE_ROLE_KEY);
const {error}=await db.from('admins').insert({name,email:email.toLowerCase(),role,password_hash:await bcrypt.hash(pw,12)});
if(error){console.error(error.message);process.exit(1)}console.log('Admin created:',email,role);
