## Real-world example: university registration spike

Imagine something like University of KwaZulu-Natal registration day:

50,000+ students logging in
Everyone hitting the system at once
Payments, forms, document uploads

👉 One server will absolutely collapse.

🧱 Basic (what you built with Compose)
With Compose, you have:

[ WordPress/PHP ]
        |
     [ MySQL ]

👉 Runs on ONE machine only
👉 No scaling
👉 If it crashes = everything down

🌍 Real production architecture

Now let’s upgrade that mentally:

        🌐 Users
           |
     Load Balancer
      /    |    \
 App 1  App 2  App 3   (containers on different servers)
      \    |    /
        Database Cluster
🔥 What orchestration actually does

Using something like Kubernetes:

1. Auto scaling
If traffic spikes:
3 containers → 10 → 50 → 100
👉 New containers spin up automatically

2. Multi-server deployment
Containers are not just on one machine:
Server A → 5 containers
Server B → 5 containers
Server C → 5 containers
👉 That’s how you handle massive load

3. Load balancing
A load balancer:
Distributes users evenly
Sends each request to a healthy container

4. Self-healing
If one container dies:
It gets restarted automatically
Users don’t notice

5. Rolling updates
Deploy new code:
No downtime
Old containers replaced gradually
🧠 Answering your exact question

“Would it start more containers on other servers and redirect users there?”

👉 Yes. Exactly that.

But:

Not Docker Compose
You need orchestration like Kubernetes
⚠️ Important reality check

For something like university registration:

👉 WordPress alone is NOT ideal
👉 You’d likely use:

Custom backend (Node, Laravel, etc.)
Queue systems (for payments)
Caching layers (Redis)
CDN for static content
🏗️ What a more realistic stack looks like
Users
  ↓
CDN (Cloudflare)
  ↓
Load Balancer
  ↓
Kubernetes Cluster
  ├── App containers (many replicas)
  ├── API services
  ├── Background workers
  ↓
Database (managed, replicated)
🆚 Compose vs Real Scaling
Feature	Docker Compose	Kubernetes
Multi-server	❌	✅
Auto scaling	❌	✅
Self-healing	❌	✅
Production ready	⚠️ Limited	✅