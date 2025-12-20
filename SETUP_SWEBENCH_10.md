# Setup for Running 10 SWE-bench Verified Tasks

This directory contains everything needed to run 10 selected tasks from the SWE-bench Verified dataset using OpenAI GPT models.

## 📁 Files Overview

| File | Purpose |
|------|---------|
| `QUICKSTART_SWEBENCH_10.md` | Quick 3-step guide to get started |
| `RUN_SWEBENCH_10.md` | Detailed documentation with all options |
| `run_swebench_10.sh` | Executable script to run the evaluation |
| `swebench_10_instances.txt` | 10 selected SWE-bench instance IDs |
| `.llm_config/openai-gpt4.json` | OpenAI API configuration template |

## 🚀 Quick Start

### 1. Install Dependencies

```bash
make build
```

This will:
- Initialize git submodules
- Install all Python dependencies
- Set up pre-commit hooks

### 2. Configure OpenAI API Key

**Option A: Edit the config file**
```bash
nano .llm_config/openai-gpt4.json
```
Replace `YOUR_OPENAI_API_KEY_HERE` with your actual OpenAI API key.

**Option B: Use environment variable**
```bash
export OPENAI_API_KEY='sk-your-actual-key-here'
```

### 3. Run the Evaluation

**Easiest method:**
```bash
./run_swebench_10.sh
```

**Or with explicit options:**
```bash
./run_swebench_10.sh --api-key 'sk-your-key' --model openai/gpt-4-turbo
```

**Or use the underlying command directly:**
```bash
uv run swebench-infer .llm_config/openai-gpt4.json \
    --select swebench_10_instances.txt \
    --dataset princeton-nlp/SWE-bench_Verified \
    --split test \
    --max-iterations 100 \
    --workspace docker
```

## 📊 What Gets Evaluated?

The 10 selected instances cover diverse Python projects:

1. **django__django-11333** - Django web framework
2. **django__django-12155** - Django web framework
3. **astropy__astropy-7746** - Astronomy library
4. **matplotlib__matplotlib-23563** - Plotting library
5. **pylint-dev__pylint-5859** - Code linter
6. **scikit-learn__scikit-learn-13142** - Machine learning library
7. **sympy__sympy-14308** - Symbolic mathematics
8. **pytest-dev__pytest-5227** - Testing framework
9. **requests__requests-2148** - HTTP library
10. **flask__flask-4992** - Web framework

These instances were selected to represent:
- Different project sizes and complexities
- Various Python domains (web, ML, testing, etc.)
- Well-known, actively maintained projects
- Diverse types of issues and fixes

## ⏱️ Expected Time & Cost

### Time
- **Sequential** (1 worker): 2-5 hours
- **Parallel** (10 workers): 20-40 minutes

### Cost (approximate)
- **GPT-4**: $20-$150 total
- **GPT-4 Turbo**: $5-$40 total
- **GPT-3.5 Turbo**: $1-$10 total

Costs vary based on:
- Problem complexity
- Number of iterations needed
- Code size and context

## 🔧 Configuration Options

### Available OpenAI Models

You can use any of these models by changing the `model` field:

```json
{
  "model": "openai/gpt-4",           // Best quality
  "model": "openai/gpt-4-turbo",     // Faster, cheaper
  "model": "openai/gpt-4o",          // GPT-4 Optimized
  "model": "openai/gpt-3.5-turbo",   // Cheapest
  "api_key": "sk-your-key-here"
}
```

### Script Options

The `run_swebench_10.sh` script supports:

```bash
--model MODEL           # OpenAI model (default: openai/gpt-4)
--api-key KEY          # API key (or use OPENAI_API_KEY env var)
--workspace TYPE       # docker or remote (default: docker)
--num-workers N        # Parallel workers (default: 1)
--max-iterations N     # Max iterations per task (default: 100)
```

### Examples

**Using GPT-4 Turbo (faster and cheaper):**
```bash
./run_swebench_10.sh --model openai/gpt-4-turbo
```

**Running in parallel with 5 workers:**
```bash
./run_swebench_10.sh --num-workers 5
```

**Using remote workspace (requires RUNTIME_API_KEY):**
```bash
export RUNTIME_API_KEY='your-runtime-key'
./run_swebench_10.sh --workspace remote --num-workers 10
```

## 📈 Evaluating Results

After the evaluation completes, results are saved to `./eval_outputs/`.

**View the results:**
```bash
uv run swebench-eval ./eval_outputs/output.jsonl
```

This will:
1. Convert OpenHands format to SWE-Bench format
2. Run official SWE-Bench evaluation
3. Show pass/fail for each instance

**Expected output:**
```
Instance: django__django-11333 - PASSED ✓
Instance: django__django-12155 - FAILED ✗
...
Total: X/10 passed
```

## 🔍 Customization

### Selecting Different Instances

Edit `swebench_10_instances.txt` to use different instances:

```bash
# Add your desired instance IDs, one per line
echo "your-instance-id" > swebench_10_instances.txt
```

### Changing Number of Instances

You can select more or fewer instances. The infrastructure supports:
- Any number from 1 to 500 (full SWE-bench Verified)
- Use `--n-limit N` to limit to first N instances
- Or use `--select file.txt` for specific instances

### Adjusting Iteration Limit

If tasks are timing out or incomplete:

```bash
./run_swebench_10.sh --max-iterations 200
```

Higher iterations allow the model more attempts to solve complex issues.

## 🐛 Troubleshooting

### "command not found: uv"
```bash
make build
```

### "Docker daemon not running"
```bash
# Start Docker
sudo systemctl start docker  # Linux
# or open Docker Desktop (Mac/Windows)
```

### "Invalid API key"
- Verify your OpenAI API key is correct
- Check that you have credits available
- Ensure no extra spaces in the config file

### "SKIP_BUILD=1 but image not found"
```bash
# Option 1: Build images during runtime
export SKIP_BUILD=0
./run_swebench_10.sh

# Option 2: Pre-build all images
uv run python -m benchmarks.swebench.build_images \
  --dataset princeton-nlp/SWE-bench_Verified \
  --split test
```

### Out of memory errors
- Reduce `--num-workers` to 1
- Close other applications
- Use remote workspace instead of Docker

## 📚 Additional Resources

- **Quick Start**: See `QUICKSTART_SWEBENCH_10.md`
- **Detailed Docs**: See `RUN_SWEBENCH_10.md`
- **SWE-Bench Guide**: See `benchmarks/swebench/README.md`
- **Main README**: See `README.md`

## 🤝 Support

For issues or questions:
1. Check the troubleshooting section above
2. Review the detailed documentation in `RUN_SWEBENCH_10.md`
3. See the main SWE-bench README at `benchmarks/swebench/README.md`
4. Consult the OpenHands documentation

## 📝 Notes

- **Security**: Never commit real API keys to git. The `.llm_config/` directory is gitignored by default.
- **Costs**: Monitor your OpenAI usage to avoid unexpected charges.
- **Time**: Initial runs may be slower as Docker images are built.
- **Results**: Success rates vary by model. GPT-4 typically performs better than GPT-3.5.

## 🎯 Next Steps After Setup

1. ✅ Run the evaluation with `./run_swebench_10.sh`
2. ✅ Wait for completion (check progress in terminal)
3. ✅ Evaluate results with `swebench-eval`
4. ✅ Analyze which tasks passed/failed
5. ✅ Adjust configuration and retry failed tasks if needed
6. ✅ Try different models to compare performance

---

**Ready to start?** Run: `./run_swebench_10.sh --help`
