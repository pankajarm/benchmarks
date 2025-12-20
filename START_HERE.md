# 🎯 SWE-bench 10-Task Setup - Complete Guide

## What Has Been Set Up

A complete, ready-to-use setup for running **10 selected tasks from SWE-bench Verified** using **OpenAI GPT models** (GPT-4, GPT-4 Turbo, etc.).

## 📦 What You Have

### Core Files
- ✅ **`.llm_config/openai-gpt4.json`** - OpenAI configuration template
- ✅ **`swebench_10_instances.txt`** - 10 carefully selected task IDs
- ✅ **`run_swebench_10.sh`** - Automated run script

### Documentation
- 📘 **`QUICKSTART_SWEBENCH_10.md`** - Get started in 3 steps (START HERE!)
- 📗 **`RUN_SWEBENCH_10.md`** - Detailed usage guide
- 📕 **`SETUP_SWEBENCH_10.md`** - Complete configuration reference

## 🚀 Get Started Now

### Step 1: Add Your OpenAI API Key

Edit the configuration file:
```bash
nano .llm_config/openai-gpt4.json
```

Replace `YOUR_OPENAI_API_KEY_HERE` with your actual OpenAI API key (starts with `sk-`).

### Step 2: Run the Evaluation

**Option A: Use the convenience script**
```bash
./run_swebench_10.sh
```

**Option B: Set API key as environment variable**
```bash
export OPENAI_API_KEY='sk-your-actual-key-here'
./run_swebench_10.sh
```

**Option C: Specify everything inline**
```bash
./run_swebench_10.sh --api-key 'sk-your-key' --model openai/gpt-4-turbo
```

### Step 3: Evaluate Results

After completion (2-5 hours):
```bash
uv run swebench-eval ./eval_outputs/output.jsonl
```

## 📊 What Will Be Evaluated

10 diverse tasks from popular Python projects:

| Project | Instance ID | Description |
|---------|-------------|-------------|
| Django | django__django-11333 | Web framework |
| Django | django__django-12155 | Web framework |
| Astropy | astropy__astropy-7746 | Astronomy library |
| Matplotlib | matplotlib__matplotlib-23563 | Plotting library |
| Pylint | pylint-dev__pylint-5859 | Code linter |
| Scikit-learn | scikit-learn__scikit-learn-13142 | ML library |
| SymPy | sympy__sympy-14308 | Symbolic math |
| Pytest | pytest-dev__pytest-5227 | Testing framework |
| Requests | requests__requests-2148 | HTTP library |
| Flask | flask__flask-4992 | Web framework |

## ⏱️ Time & Cost Estimates

### Time
- **Sequential** (default): 2-5 hours
- **Parallel** (10 workers): 20-40 minutes

### Cost
- **GPT-4**: $20-$150
- **GPT-4 Turbo**: $5-$40
- **GPT-3.5 Turbo**: $1-$10

## 🎛️ Configuration Options

### Change the Model

Edit `.llm_config/openai-gpt4.json` or use the script:

```bash
# Use GPT-4 Turbo (faster, cheaper)
./run_swebench_10.sh --model openai/gpt-4-turbo

# Use GPT-3.5 Turbo (cheapest)
./run_swebench_10.sh --model openai/gpt-3.5-turbo
```

### Run in Parallel

```bash
# Run with 5 workers
./run_swebench_10.sh --num-workers 5

# Run with 10 workers (one per task)
./run_swebench_10.sh --num-workers 10
```

### Increase Iteration Limit

```bash
# Allow up to 200 iterations per task
./run_swebench_10.sh --max-iterations 200
```

## 📖 Documentation Guide

**Choose your path:**

1. **Just want to run it?** → Read `QUICKSTART_SWEBENCH_10.md`
2. **Want all the details?** → Read `RUN_SWEBENCH_10.md`
3. **Need configuration help?** → Read `SETUP_SWEBENCH_10.md`

## ⚡ Quick Reference

### Run with Default Settings
```bash
./run_swebench_10.sh
```

### Run with GPT-4 Turbo
```bash
./run_swebench_10.sh --model openai/gpt-4-turbo
```

### Run in Parallel (10 workers)
```bash
./run_swebench_10.sh --num-workers 10
```

### Evaluate Results
```bash
uv run swebench-eval ./eval_outputs/output.jsonl
```

## 🐛 Common Issues

**"command not found: uv"**
```bash
make build
```

**"Invalid API key"**
- Check your API key in `.llm_config/openai-gpt4.json`
- Ensure no extra spaces
- Verify you have OpenAI credits

**"Docker not running"**
```bash
docker ps  # Check if Docker is running
# Start Docker if needed
```

## 🎓 Understanding the Output

After running, you'll see:
- Real-time progress for each task
- Token usage and costs
- Generated patches for each instance
- Final results in `./eval_outputs/`

The evaluation step will show:
- Which tasks passed ✅
- Which tasks failed ❌
- Overall success rate

## 🔄 Next Steps After First Run

1. Review the results in `./eval_outputs/`
2. Check which instances passed/failed
3. Try different models to compare performance
4. Adjust `--max-iterations` for better results
5. Experiment with different instances

## 📚 Additional Resources

- **SWE-Bench Official**: https://www.swebench.com/
- **OpenAI API Docs**: https://platform.openai.com/docs
- **Repository README**: See `README.md` in root
- **SWE-Bench Benchmark Guide**: See `benchmarks/swebench/README.md`

## ⚠️ Important Notes

- **Never commit your API key to git** - The config file has a placeholder
- **Monitor your costs** - Set usage limits in OpenAI dashboard
- **First run may be slow** - Docker images need to be built
- **Success varies by model** - GPT-4 typically outperforms GPT-3.5

## 🤝 Need Help?

1. Check the troubleshooting section above
2. Review the detailed docs in `RUN_SWEBENCH_10.md`
3. See `SETUP_SWEBENCH_10.md` for configuration help
4. Consult the main repository README

## ✨ Ready to Start?

**Fastest path to running:**
```bash
# 1. Edit config with your API key
nano .llm_config/openai-gpt4.json

# 2. Run the evaluation
./run_swebench_10.sh

# 3. Wait for completion, then evaluate
uv run swebench-eval ./eval_outputs/output.jsonl
```

**That's it!** 🎉

---

*This setup was created to make it easy to run 10 SWE-bench Verified tasks using OpenAI GPT models. All files are ready - you just need to add your API key and run!*
