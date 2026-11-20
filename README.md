# 机甲杯 · 视觉组代码仓库

这是我（xiaomei2061）在机甲杯算法组做视觉部分的代码仓库。
用 git 做版本管理，托管在 GitHub 上。

---

## 0. 先说清楚：git 到底在干什么

| 你平时的习惯 | git 的做法 |
| --- | --- |
| 改完文件，另存为「test_最终版_真的最终版.py」 | 所有版本都存在同一个 `test.py` 里，随时能翻回去 |
| 电脑坏了 / U 盘丢了代码就没了 | 代码在 GitHub 上还有一份 |
| 不知道昨天改了哪一行 | `git diff` 能逐行告诉你 |

三个词，记住就行：

- **提交（commit）** = 给当前这一版代码拍张快照，存在自己电脑上。
- **推送（push）** = 把快照传到 GitHub。
- **仓库（repository）** = 装着所有快照的那个文件夹。

---

## 1. 每天怎么用（只记这一件事）

改完代码，**双击 `保存并上传.bat`**，看到 `上传成功！` 就行。
它会自动完成：拍快照 → 传 GitHub。不用敲任何命令。

> 如果窗口一闪就关了，说明报错了；往上翻看红色那几行，或者对照下面第 4 节。

---

## 2. 第一次设置（已完成 ✅）

> **这一节已经做完了，留在这里是为了以后换电脑时能照着重做一遍。**
> 现状：仓库已连上 <https://github.com/xiaomei2061/Robot_Vision>，日常只需双击 `保存并上传.bat`。

### 第 1 步：在 GitHub 上建一个空仓库

1. 浏览器打开 <https://github.com/new>
2. `Repository name` 填：`Robot_Vision`
3. 选 `Private`（私有）或 `Public`（公开）都可以。
4. **下面的 `Add a README file`、`Add .gitignore`、`Choose a license` 全部不要勾！**
   勾了会让本地和线上对不上，第一次推送会报错。
5. 点 `Create repository`。

### 第 2 步：把仓库地址告诉本地 git

打开 VS Code，按 `` Ctrl + ` `` 打开终端，粘贴下面两行（一行一行回车）：

```powershell
& "D:\git\Git\cmd\git.exe" remote add origin https://github.com/xiaomei2061/Robot_Vision.git
& "D:\git\Git\cmd\git.exe" push -u origin main
```

第二条命令执行时会**自动弹出浏览器**，让你登录 GitHub（这是 Git 自带的凭据管理器，安全、只弹这一次）。
登录完回到终端，看到 `branch 'main' set up to track 'origin/main'` 就成功了。

### 第 3 步：以后就只剩双击 `保存并上传.bat` 了

---

## 3. 这个仓库里有什么

```
Robot_Vision/
├─ test.py                 # 打开摄像头并实时显示（第一版）
├─ save_and_push.ps1       # 「保存并上传」的实际逻辑，不用直接开
├─ 保存并上传.bat           # 你双击的就是它
├─ .gitignore              # 哪些文件不该上传（见下）
└─ README.md               # 就是这份说明
```

`.gitignore` 里排除了这几类，**它们不会上传**（很正常，不是 bug）：

- `__pycache__/`、`venv/` —— 运行时的临时文件、虚拟环境
- `*.jpg / *.png / *.mp4` —— 图片视频太大，GitHub 传不动
- `*.onnx / *.pt` —— 训练好的模型文件，以后单独用网盘或 Release 放

> 所以：**录的比赛视频、拍的照片不要往这里塞**，太大会把仓库拖垮。

---

## 4. 常见问题

**1）`保存并上传.bat` 提示「上传失败」，还跳出登录窗口**
按提示登录 GitHub 就行。如果窗口一闪而过：
VS Code 终端里跑一次 `& "D:\git\Git\cmd\git.exe" push`，看完整报错。

**2）`git` 命令提示「无法将"git"项识别为 cmdlet…」**
原因：Git 装在了 `D:\git\Git`，但系统 PATH 里写的是 `D:\新建文件夹 (6)\Git\cmd`（这个文件夹已经被你移走了，所以找不到）。
修复：把 `D:\git\Git\cmd` 加到用户环境变量 `Path` 里，然后**关掉所有终端窗口重新打开**。

**3）`fatal: not a git repository`**
说明当前终端不在 `D:\Robot_Vision` 下。先 `cd D:\Robot_Vision`。

**4）`error: failed to push some refs` / `rejected`**
线上有你本地没有的东西（通常是建仓库时勾了 README）。最简单的解决办法：
把 GitHub 上的仓库删掉，按第 2 节第 1 步重新建一个**空**的。

**5）VS Code 终端下拉里没有「Git Bash」，或者点了打不开**
原因：VS Code 靠注册表 `HKLM\SOFTWARE\GitForWindows\InstallPath` 去自动发现 Git Bash，
而那一项还写着老路径 `D:\新建文件夹 (6)\Git`（文件夹已经被移走了）。
解决：已经在用户设置里显式写死了 Git Bash 的完整路径，不用管注册表了：

```json
"terminal.integrated.profiles.windows": {
    "Git Bash": {
        "path": "D:\\git\\Git\\bin\\bash.exe",
        "args": ["--login", "-i"],
        "icon": "terminal-bash"
    }
},
"terminal.integrated.defaultProfile.windows": "Git Bash"
```

改完要 **关掉所有终端标签页**（点终端右上角的垃圾桶 x），再点 `+` 新建，才会用新配置。

**6）提交记录里作者名字不对**
在仓库目录跑：
```powershell
& "D:\git\Git\cmd\git.exe" config user.name "xiaomei2061"
& "D:\git\Git\cmd\git.exe" config user.email "xiaomei2061@users.noreply.github.com"
```
（只影响以后的提交，已提交的不会变。）

---

## 5. 视觉部分要交什么（中期考核，共 70 分）

| 题目 | 分值 | 对应要会的东西 |
| --- | --- | --- |
| 识别能量机关「待激活 / 已激活」两种灯效，并在图上标注 | 10 | OpenCV 颜色阈值 + 轮廓检测 |
| 调用相机并实时显示画面 | 10 | ✅ 已完成（`test.py`） |
| 解算待激活靶位姿，算出枪管需要的转角 | 10 | 相机内参、PnP 解算、（可选）手眼标定 |
| 部署到仿真环境，逐阶段击打能量机关 | 40 | 上面全做对 + 控制接口对接 |

灯效规则（规则文档第 24 页）：

- **未激活**：4 条灯条全灭 → 不是目标
- **待激活**：4 条灯全亮 → **当前唯一有效目标**
- **已激活**：只有左右 2 条亮 → 打过了，重复命中无效

> 所以视觉要输出的核心结果就一句话：**当前哪个靶的 4 条灯全亮，它在图像的什么位置**。

---

## 6. 学习顺序（按这个走，不会白学）

1. **Python 基础**：变量、`if`、`for`、函数、列表、字典。够用就行，不用学完再动手。
2. **OpenCV 基础**：读图、`cvtColor` 转 HSV、`inRange` 抠颜色、`findContours` 找轮廓、`drawContours` 画框。
3. **把灯效识别跑通**：先在录好的视频上跑，再上实机摄像头。
4. **相机标定**：`cv2.calibrateCamera`，得到内参矩阵和畸变系数。
5. **位姿解算**：`cv2.solvePnP`，输入靶面的 3D 坐标和图像上的 2D 点，输出旋转 + 平移。
6. **转角计算**：位姿 → 云台 pitch/yaw → 串口下发给下位机。

第 1～3 步是中期考核最容易拿到的 20 分，**先做这个**。
