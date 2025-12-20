# Quick Start: Run 10 SWE-bench Tasks with OpenAI GPT

This setup allows you to quickly run 10 selected tasks from SWE-bench Verified using OpenAI GPT models.

## Files Created

1. **`.llm_config/openai-gpt4.json`** - LLM configuration file (needs your API key)
2. **`swebench_10_instances.txt`** - List of 10 selected SWE-bench instance IDs
3. **`run_swebench_10.sh`** - Convenient bash script to run the evaluation
4. **`RUN_SWEBENCH_10.md`** - Detailed documentation and guide

## Quick Start (3 Steps)

### 1. Add Your OpenAI API Key

Edit `.llm_config/openai-gpt4.json` and replace `YOUR_OPENAI_API_KEY_HERE` with your actual key:

```bash
# Option 1: Edit the file manually
nano .llm_config/openai-gpt4.json

# Option 2: Use sed to replace it
sed -i 's/YOUR_OPENAI_API_KEY_HERE/sk-your-actual-key/' .llm_config/openai-gpt4.json
```

### 2. Run the Evaluation

**Easiest method (using the script):**

```bash
# Set your API key as environment variable
export OPENAI_API_KEY='sk-your-actual-key-here'

# Run the evaluation
./run_swebench_10.sh
```

**Or specify the API key directly:**

```bash
./run_swebench_10.sh --api-key 'sk-your-key' --model openai/gpt-4-turbo
```

**Or use the command directly:**

```bash
uv run swebench-infer .llm_config/openai-gpt4.json \
    --select swebench_10_instances.txt \
    --dataset princeton-nlp/SWE-bench_Verified \
    --split test \
    --max-iterations 100 \
    --workspace docker \
    --num-workers 1
```

### 3. Evaluate Results

After the evaluation completes:

```bash
uv run swebench-eval ./eval_outputs/output.jsonl
```

## Available Models

You can use any of these OpenAI models by changing the `model` field in the config file or using the `--model` argument:

- `openai/gpt-4` - Best quality
- `openai/gpt-4-turbo` - Faster and cheaper
- `openai/gpt-4o` - GPT-4 Optimized
- `openai/gpt-3.5-turbo` - Cheapest option

## Selected Instances

The 10 instances selected are:

1. django__django-11333
2. django__django-12155
3. astropy__astropy-7746
4. matplotlib__matplotlib-23563
5. pylint-dev__pylint-5859
6. scikit-learn__scikit-learn-13142
7. sympy__sympy-14308
8. pytest-dev__pytest-5227
9. requests__requests-2148
10. flask__flask-4992

These represent diverse Python projects and issue types.

## Expected Time and Cost

- **Time**: 2-5 hours (sequential) or 20-40 minutes (10 parallel workers)
- **Cost**: $20-$150 (GPT-4) or $5-$40 (GPT-4 Turbo)

## Troubleshooting

**No uv command found?**
```bash
make build
```

**Docker not running?**
```bash
docker ps
# If error, start Docker
```

**Want to use different instances?**
Edit `swebench_10_instances.txt` with your desired instance IDs (one per line)

## More Information

See `RUN_SWEBENCH_10.md` for detailed documentation including:
- Remote workspace setup
- Cost estimation
- Monitoring progress
- Alternative configurations
- Troubleshooting guide

## Support

For issues or questions:
- Check the main README.md
- See benchmarks/swebench/README.md for SWE-bench details
- Review the OpenHands documentation
