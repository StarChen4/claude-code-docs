import { defineConfig } from 'vitepress'

// https://vitepress.dev/reference/site-config
export default defineConfig({
  title: "ClaudeCode 使用教程",
  description: "ClaudeCode CLI、VSCode 和 JetBrains 插件完整使用指南",
  lang: 'zh-CN',

  // 主题配置
  themeConfig: {
    // https://vitepress.dev/reference/default-theme-config
    logo: '/logo.svg',

    // 导航栏
    nav: [
      { text: '首页', link: '/' },
      { text: '快速开始', link: '/guide/introduction' },
      { text: '进阶教程', link: '/advanced/memory' },
      { text: '参考', link: '/reference/commands' }
    ],

    // 侧边栏
    sidebar: [
      {
        text: '基础教程',
        collapsed: false,
        items: [
          { text: '安装指南', link: '/guide/installation' },
          { text: 'ClaudeCode 介绍', link: '/guide/introduction' },
          { text: '模式切换', link: '/guide/modes' },
          { text: '基本命令', link: '/guide/basic-commands' }
        ]
      },
      {
        text: '核心功能',
        collapsed: false,
        items: [
          { text: 'Memory 使用', link: '/advanced/memory' },
          { text: '命令行操作', link: '/advanced/cli-operations' },
          { text: '权限管理', link: '/advanced/permissions' },
          { text: '自定义命令', link: '/advanced/custom-commands' }
        ]
      },
      {
        text: '进阶应用',
        collapsed: false,
        items: [
          { text: 'SubAgent 详解', link: '/advanced/subagent' },
          { text: 'Resume 功能', link: '/advanced/resume' },
          { text: 'Git 集成', link: '/advanced/git-integration' },
          { text: '需求驱动开发', link: '/advanced/requirement-driven' }
        ]
      },
      {
        text: '参考文档',
        collapsed: false,
        items: [
          { text: '命令速查', link: '/reference/commands' },
          { text: '常见问题', link: '/reference/faq' },
          { text: '故障排查', link: '/reference/troubleshooting' }
        ]
      }
    ],

    // 社交链接
    socialLinks: [
      // 可根据需要添加
    ],

    // 页脚
    footer: {
      message: 'ClaudeCode 内网使用教程',
      copyright: 'Copyright © 2025'
    },

    // 搜索
    search: {
      provider: 'local',
      options: {
        locales: {
          root: {
            translations: {
              button: {
                buttonText: '搜索文档',
                buttonAriaLabel: '搜索文档'
              },
              modal: {
                noResultsText: '无法找到相关结果',
                resetButtonTitle: '清除查询条件',
                footer: {
                  selectText: '选择',
                  navigateText: '切换'
                }
              }
            }
          }
        }
      }
    },

    // 文档页脚
    docFooter: {
      prev: '上一页',
      next: '下一页'
    },

    // 大纲标题
    outlineTitle: '本页目录',

    // 最后更新时间文本
    lastUpdated: {
      text: '最后更新于',
      formatOptions: {
        dateStyle: 'short',
        timeStyle: 'medium'
      }
    }
  },

  // 最后更新时间
  lastUpdated: true,

  // Markdown 配置
  markdown: {
    lineNumbers: true,
    theme: {
      light: 'github-light',
      dark: 'github-dark'
    }
  }
})
