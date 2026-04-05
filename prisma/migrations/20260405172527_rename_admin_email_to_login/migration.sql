/*
  Warnings:

  - You are about to drop the column `email` on the `Admin` table. All the data in the column will be lost.
  - You are about to drop the column `branchQuestionEnabled` on the `Organization` table. All the data in the column will be lost.
  - You are about to drop the column `email` on the `Organization` table. All the data in the column will be lost.
  - Added the required column `login` to the `Admin` table without a default value. This is not possible if the table is not empty.
  - Added the required column `login` to the `Organization` table without a default value. This is not possible if the table is not empty.

*/
-- CreateTable
CREATE TABLE "Meeting" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "candidateId" TEXT NOT NULL,
    "scheduledAt" DATETIME NOT NULL,
    "note" TEXT,
    "reminderMinutes" INTEGER NOT NULL DEFAULT 30,
    "reminderSent" BOOLEAN NOT NULL DEFAULT false,
    "status" TEXT NOT NULL DEFAULT 'scheduled',
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    CONSTRAINT "Meeting_candidateId_fkey" FOREIGN KEY ("candidateId") REFERENCES "Candidate" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Admin" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "login" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "role" TEXT NOT NULL DEFAULT 'admin',
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL
);
INSERT INTO "new_Admin" ("createdAt", "id", "isActive", "name", "password", "role", "updatedAt") SELECT "createdAt", "id", "isActive", "name", "password", "role", "updatedAt" FROM "Admin";
DROP TABLE "Admin";
ALTER TABLE "new_Admin" RENAME TO "Admin";
CREATE UNIQUE INDEX "Admin_login_key" ON "Admin"("login");
CREATE TABLE "new_KanbanColumn" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "botId" TEXT,
    "name" TEXT NOT NULL,
    "color" TEXT NOT NULL DEFAULT 'bg-slate-50',
    "dot" TEXT NOT NULL DEFAULT 'bg-slate-400',
    "order" INTEGER NOT NULL DEFAULT 0,
    "isArchived" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL,
    CONSTRAINT "KanbanColumn_botId_fkey" FOREIGN KEY ("botId") REFERENCES "Bot" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO "new_KanbanColumn" ("botId", "color", "createdAt", "dot", "id", "isArchived", "name", "order", "updatedAt") SELECT "botId", "color", "createdAt", "dot", "id", "isArchived", "name", "order", "updatedAt" FROM "KanbanColumn";
DROP TABLE "KanbanColumn";
ALTER TABLE "new_KanbanColumn" RENAME TO "KanbanColumn";
CREATE TABLE "new_Organization" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "name" TEXT NOT NULL,
    "login" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "deletedAt" DATETIME,
    "createdAt" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME NOT NULL
);
INSERT INTO "new_Organization" ("createdAt", "deletedAt", "id", "isActive", "name", "password", "updatedAt") SELECT "createdAt", "deletedAt", "id", "isActive", "name", "password", "updatedAt" FROM "Organization";
DROP TABLE "Organization";
ALTER TABLE "new_Organization" RENAME TO "Organization";
CREATE UNIQUE INDEX "Organization_login_key" ON "Organization"("login");
CREATE TABLE "new_QuestionOption" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "questionId" TEXT NOT NULL,
    "order" INTEGER NOT NULL DEFAULT 0,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "branchId" TEXT,
    CONSTRAINT "QuestionOption_questionId_fkey" FOREIGN KEY ("questionId") REFERENCES "Question" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "QuestionOption_branchId_fkey" FOREIGN KEY ("branchId") REFERENCES "Branch" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);
INSERT INTO "new_QuestionOption" ("id", "isActive", "order", "questionId") SELECT "id", "isActive", "order", "questionId" FROM "QuestionOption";
DROP TABLE "QuestionOption";
ALTER TABLE "new_QuestionOption" RENAME TO "QuestionOption";
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
