from fpdf import FPDF  # Import FPDF

# Fixing encoding issue by replacing the en-dash with a regular dash
pdf = FPDF()

# Add a page
pdf.add_page()

# Set title font
pdf.set_font('Arial', 'B', 16)
pdf.cell(200, 10, 'Pratik Joshi', ln=True, align='C')

# Contact Information
pdf.set_font('Arial', '', 12)
pdf.cell(200, 10, 'Email: pratik.joshi@example.com | Phone: +91-XXXXXXXXXX | LinkedIn: linkedin.com/in/pratikjoshi', ln=True, align='C')
pdf.cell(200, 10, 'Location: Goa, India', ln=True, align='C')

# Objective
pdf.set_font('Arial', 'B', 14)
pdf.cell(200, 10, 'Objective', ln=True, align='L')
pdf.set_font('Arial', '', 12)
pdf.multi_cell(0, 10, 'A motivated and detail-oriented Cloud Operations Engineer with 1.5 years of experience in AWS Cloud. Skilled in cloud infrastructure management, automation, monitoring, and security best practices. Proficient in leveraging AWS services to build scalable, reliable, and cost-effective solutions.')

# Skills Section
pdf.set_font('Arial', 'B', 14)
pdf.cell(200, 10, 'Skills', ln=True, align='L')
pdf.set_font('Arial', '', 12)
pdf.multi_cell(0, 10, """
- Cloud Platforms: AWS (EC2, S3, RDS, Lambda, CloudWatch, IAM, VPC, Route 53)
- DevOps Tools: Docker, Kubernetes, Jenkins, Terraform, GitHub Actions
- Monitoring and Logging: ELK Stack (Elasticsearch, Logstash, Kibana), CloudWatch, Filebeat
- Scripting: Shell Scripting, Python (basic understanding)
- Linux Administration: Disk management, LVM, system monitoring, automation
- Storage: NFS, EBS, S3, Backup Strategies, Rsyslog
- Networking: VPC setup, Security Groups, Load Balancers
""")

# Professional Experience Section
pdf.set_font('Arial', 'B', 14)
pdf.cell(200, 10, 'Professional Experience', ln=True, align='L')

# Job Title and Company
pdf.set_font('Arial', 'B', 12)
pdf.cell(200, 10, 'Cloud Engineer | XYZ Cloud Solutions', ln=True, align='L')
pdf.set_font('Arial', '', 12)
pdf.cell(200, 10, 'Jan 2023 - Present', ln=True, align='R')

# Job Responsibilities
pdf.set_font('Arial', '', 12)
pdf.multi_cell(0, 10, """
- Managed AWS infrastructure, including EC2 instances, S3 buckets, RDS databases, and VPC configurations.
- Implemented security best practices by managing IAM roles, security groups, and configuring VPCs with subnets, NAT gateways.
- Automated deployment processes using Terraform and managed Kubernetes clusters for application deployment.
- Set up continuous integration and deployment pipelines using Jenkins and GitHub Actions.
- Monitored system performance and availability using CloudWatch and ELK stack; resolved incidents and optimized cloud costs.
- Collaborated with developers to troubleshoot application issues and implement best practices for cloud-native applications.
- Managed storage solutions, including S3, EBS, and automated backups using shell scripts.
""")

# Job Title and Company
pdf.set_font('Arial', 'B', 12)
pdf.cell(200, 10, 'Cloud Intern | ABC Tech Labs', ln=True, align='L')
pdf.set_font('Arial', '', 12)
pdf.cell(200, 10, 'Jun 2022 - Dec 2022', ln=True, align='R')

# Job Responsibilities
pdf.set_font('Arial', '', 12)
pdf.multi_cell(0, 10, """
- Assisted in setting up AWS resources such as EC2, S3, and RDS instances for client projects.
- Monitored and optimized cloud infrastructure performance using CloudWatch.
- Worked on backup and disaster recovery solutions, ensuring data security and availability.
- Learned and contributed to the automation of cloud infrastructure using Terraform.
""")

# Education
pdf.set_font('Arial', 'B', 14)
pdf.cell(200, 10, 'Education', ln=True, align='L')
pdf.set_font('Arial', '', 12)
pdf.cell(200, 10, 'Bachelor of Computer Applications (BCA) | Goa University', ln=True, align='L')
pdf.cell(200, 10, 'Graduated: 2022', ln=True, align='L')

# Certificates
pdf.set_font('Arial', 'B', 14)
pdf.cell(200, 10, 'Certifications', ln=True, align='L')
pdf.set_font('Arial', '', 12)
pdf.multi_cell(0, 10, """
- AWS Certified Solutions Architect - Associate
- Databricks Certified Developer
""")

# Save the PDF to file
pdf_output_path = "./Pratik_Joshi_Cloud_Operations_Engineer_Resume.pdf"
pdf.output(pdf_output_path)

pdf_output_path
