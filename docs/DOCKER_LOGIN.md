# Docker Hub Login Instructions

## Why Sign In?

Docker Hub has rate limits:
- **Anonymous users**: 100 pulls per 6 hours per IP
- **Free account**: 200 pulls per 6 hours
- Signing in prevents "unauthorized" and timeout errors

## How to Sign In

### Option 1: Via Docker Desktop (Easiest)

1. Open Docker Desktop
2. Click the "Sign in" button in the top right
3. If you don't have an account, click "Sign up" (it's free)
4. Enter your credentials
5. Wait for "Signed in" confirmation

### Option 2: Via Command Line

```bash
# Sign in
docker login

# Enter your Docker Hub username and password when prompted
```

### Option 3: Create Free Account First

If you don't have a Docker Hub account:

1. Go to https://hub.docker.com/signup
2. Create a free account (just email and password)
3. Verify your email
4. Sign in via Docker Desktop or command line

## After Signing In

Run the build again:

```bash
./build-with-docker.sh
```

## No Account? No Problem!

If you don't want to create a Docker Hub account, use **GitHub Actions** instead:
- No Docker needed
- No account needed (if you already have GitHub)
- Builds in the cloud
- Just as fast

See `docs/CLOUD_BUILD.md` for instructions.
