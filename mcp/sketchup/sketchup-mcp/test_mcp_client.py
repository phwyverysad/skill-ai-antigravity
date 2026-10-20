import asyncio
import json
from mcp import ClientSession, StdioServerParameters
from mcp.client.stdio import stdio_client

async def test_mcp_client():
    server_params = StdioServerParameters(
        command="C:\\Python314\\python.exe",
        args=["-m", "sketchup_mcp.server"]
    )
    async with stdio_client(server_params) as (read, write):
        async with ClientSession(read, write) as session:
            await session.initialize()
            
            print("--- 1. Calling eval_ruby via MCP ---")
            eval_res = await session.call_tool(
                "eval_ruby",
                arguments={"code": 'Active entities count: #{Sketchup.active_model.entities.count}'}
            )
            print("eval_ruby response:", eval_res.content[0].text)

            print("--- 2. Calling create_component via MCP ---")
            box_res = await session.call_tool(
                "create_component",
                arguments={
                    "type": "cube",
                    "dimensions": [20.0, 30.0, 40.0],
                    "position": [50.0, 50.0, 0.0]
                }
            )
            print("create_component response:", box_res.content[0].text)

            print("--- 3. Calling get_selection via MCP ---")
            sel_res = await session.call_tool(
                "get_selection",
                arguments={}
            )
            print("get_selection response:", sel_res.content[0].text)

if __name__ == "__main__":
    asyncio.run(test_mcp_client())
