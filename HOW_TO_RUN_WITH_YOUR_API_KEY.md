# How to Run the Benchmark with Your API Key

## ⚠️ CRITICAL SECURITY ACTION REQUIRED

**IMMEDIATELY REVOKE THE API KEY YOU SHARED:**
1. Go to: https://platform.openai.com/api-keys
2. Find the key starting with `sk-2Uzd2hKn...`
3. Click "Revoke" or "Delete"
4. Create a NEW API key and keep it secure

**Why?** The API key you shared in the comment is now visible in this repository's history and could be used by anyone.

## Configuration Validated ✅

Your setup is **ready to run**! I've validated:

- ✅ Configuration file format is correct
- ✅ 10 SWE-bench instances selected
- ✅ Model: `openai/gpt-4`
- ✅ All necessary files in place

## Environment Limitations 🚧

**This sandboxed environment CANNOT run the full benchmark because:**

1. **Limited Internet Access**: Cannot download the SWE-bench Verified dataset from HuggingFace
2. **Runtime Constraints**: The benchmark takes 2-5 hours (or 20-40 minutes with parallel workers)
3. **API Costs**: Running the benchmark will cost $20-$150 in OpenAI API calls
4. **No Persistence**: Evaluation outputs may not be saved properly in this environment

## How to Run Locally (RECOMMENDED) 🚀

### Step 1: Set Up Your Local Environment

```bash
# Clone this repository
git clone https://github.com/pankajarm/benchmarks.git
cd benchmarks

# Switch to this branch
git checkout copilot/run-tasks-on-swe-bench

# Install dependencies
make build
```

### Step 2: Add Your NEW API Key

**IMPORTANT:** Use a NEW key, not the one you shared in comments!

```bash
# Edit the configuration file
nano .llm_config/openai-gpt4.json

# Replace YOUR_OPENAI_API_KEY_HERE with your new key
```

The file should look like:
```json
{
  "model": "openai/gpt-4",
  "api_key": "sk-your-new-key-here"
}
```

### Step 3: Run the Benchmark

**Option A: Using the convenience script**
```bash
./run_swebench_10.sh
```

**Option B: With explicit options**
```bash
# Run with GPT-4 Turbo (cheaper and faster)
./run_swebench_10.sh --model openai/gpt-4-turbo --num-workers 1

# Run with 10 parallel workers (faster, requires more resources)
./run_swebench_10.sh --num-workers 10
```

**Option C: Direct command**
```bash
uv run swebench-infer .llm_config/openai-gpt4.json \
    --select swebench_10_instances.txt \
    --dataset princeton-nlp/SWE-bench_Verified \
    --split test \
    --max-iterations 100 \
    --workspace docker \
    --num-workers 1
```

### Step 4: Monitor Progress

The benchmark will show progress in real-time:
```
Processing instance 1/10: django__django-11333
Agent iteration 1/100...
Agent iteration 2/100...
...
Instance completed! Generated patch saved.

Processing instance 2/10: django__django-12155
...
```

### Step 5: Evaluate Results

After completion (2-5 hours):
```bash
uv run swebench-eval ./eval_outputs/output.jsonl
```

This will show which tasks passed:
```
Instance: django__django-11333 - PASSED ✓
Instance: django__django-12155 - FAILED ✗
...
Total: X/10 passed
```

## Expected Results 📊

### Time
- **Sequential** (1 worker): 2-5 hours
- **Parallel** (10 workers): 20-40 minutes

### Cost
- **GPT-4**: $20-$150
- **GPT-4 Turbo**: $5-$40 (recommended)
- **GPT-3.5 Turbo**: $1-$10

### Success Rate
- GPT-4: typically 3-5 out of 10 pass (30-50%)
- GPT-4 Turbo: typically 2-4 out of 10 pass (25-45%)

## Troubleshooting 🔧

### "command not found: uv"
```bash
make build
```

### "Cannot connect to Docker daemon"
```bash
# Check Docker is running
docker ps

# Start Docker if needed
```

### "Dataset download failed"
- Ensure you have internet connectivity
- Check HuggingFace is accessible

### "Out of memory"
- Reduce `--num-workers` to 1
- Close other applications
- Increase Docker memory limit

## Cost Control 💰

To minimize costs while testing:

1. **Start small**: Run just 1-2 instances first
   ```bash
   # Create a test file with 2 instances
   head -2 swebench_10_instances.txt > test_instances.txt
   
   # Run with test file
   ./run_swebench_10.sh --select test_instances.txt
   ```

2. **Use cheaper model**: Try GPT-4 Turbo or GPT-3.5 first
   ```bash
   ./run_swebench_10.sh --model openai/gpt-4-turbo
   ```

3. **Set spending limits**: Configure in OpenAI dashboard
   - Go to: https://platform.openai.com/account/billing/limits
   - Set monthly budget limit

4. **Reduce iterations**: Lower the max iterations
   ```bash
   ./run_swebench_10.sh --max-iterations 50
   ```

## What I Validated in This Environment ✓

Despite the limitations, I successfully validated:

1. ✅ Configuration file format is correct
2. ✅ All 10 instance IDs are properly formatted
3. ✅ The script structure is valid
4. ✅ Docker is available and running
5. ✅ All necessary files are in place

## Next Steps 🎯

1. **FIRST**: Revoke the API key you shared in comments
2. **SECOND**: Create a new API key from OpenAI dashboard
3. **THIRD**: Clone this repo to your local machine
4. **FOURTH**: Follow the "How to Run Locally" steps above
5. **FIFTH**: Start with a small test (1-2 instances) to verify everything works
6. **SIXTH**: Run the full 10 instances once you're confident

## Files Ready for You 📁

All files are committed and ready in this branch:

- `.llm_config/openai-gpt4.json` - Config template (add your NEW key)
- `swebench_10_instances.txt` - 10 selected instances
- `run_swebench_10.sh` - Executable script
- `START_HERE.md` - Quick reference
- `QUICKSTART_SWEBENCH_10.md` - 3-step guide
- `RUN_SWEBENCH_10.md` - Detailed documentation
- `SETUP_SWEBENCH_10.md` - Configuration guide

## Questions? 🤔

Refer to the documentation files:
- Quick start: `QUICKSTART_SWEBENCH_10.md`
- Detailed guide: `RUN_SWEBENCH_10.md`
- Troubleshooting: `SETUP_SWEBENCH_10.md`

---

**Ready to run the benchmark?** Clone the repo to your local machine and follow the steps above!
