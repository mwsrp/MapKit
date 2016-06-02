//
//  MapKitQuadTree.m
//  HelloCordova
//
//  Created by James Mattis on 6/1/16.
//
//

#import "MapKitQuadTree.h"

#pragma mark - Constructors

MKQuadTreeNodeData MKQuadTreeNodeDataMake(double x, double y, NSInteger data)
{
    MKQuadTreeNodeData d; d.x = x; d.y = y; d.data = data;
    return d;
}

MKBoundingBox MKBoundingBoxMake(double x0, double y0, double xf, double yf)
{
    MKBoundingBox bb; bb.x0 = x0; bb.y0 = y0; bb.xf = xf; bb.yf = yf;
    return bb;
}

MKQuadTreeNode* MKQuadTreeNodeMake(MKBoundingBox boundary, int bucketCapacity)
{
    MKQuadTreeNode* node = malloc(sizeof(MKQuadTreeNode));
    node->northWest = NULL;
    node->northEast = NULL;
    node->southWest = NULL;
    node->southEast = NULL;
    
    node->boundingBox = boundary;
    node->bucketCapacity = bucketCapacity;
    node->count = 0;
    node->points = malloc(sizeof(MKQuadTreeNodeData) * bucketCapacity);
    
    return node;
}

#pragma mark - Bounding Box Functions

bool MKBoundingBoxContainsData(MKBoundingBox box, MKQuadTreeNodeData data)
{
    bool containsX = box.x0 <= data.x && data.x <= box.xf;
    bool containsY = box.y0 <= data.y && data.y <= box.yf;
    
    return containsX && containsY;
}

bool MKBoundingBoxIntersectsBoundingBox(MKBoundingBox b1, MKBoundingBox b2)
{
    return (b1.x0 <= b2.xf && b1.xf >= b2.x0 && b1.y0 <= b2.yf && b1.yf >= b2.y0);
}

#pragma mark - Quad Tree Functions

void MKQuadTreeNodeSubdivide(MKQuadTreeNode* node)
{
    MKBoundingBox box = node->boundingBox;
    
    double xMid = (box.xf + box.x0) / 2.0;
    double yMid = (box.yf + box.y0) / 2.0;
    
    MKBoundingBox northWest = MKBoundingBoxMake(box.x0, box.y0, xMid, yMid);
    node->northWest = MKQuadTreeNodeMake(northWest, node->bucketCapacity);
    
    MKBoundingBox northEast = MKBoundingBoxMake(xMid, box.y0, box.xf, yMid);
    node->northEast = MKQuadTreeNodeMake(northEast, node->bucketCapacity);
    
    MKBoundingBox southWest = MKBoundingBoxMake(box.x0, yMid, xMid, box.yf);
    node->southWest = MKQuadTreeNodeMake(southWest, node->bucketCapacity);
    
    MKBoundingBox southEast = MKBoundingBoxMake(xMid, yMid, box.xf, box.yf);
    node->southEast = MKQuadTreeNodeMake(southEast, node->bucketCapacity);
}

bool MKQuadTreeNodeInsertData(MKQuadTreeNode* node, MKQuadTreeNodeData data)
{
    if (!MKBoundingBoxContainsData(node->boundingBox, data)) {
        return false;
    }
    
    if (node->count < node->bucketCapacity) {
        node->points[node->count++] = data;
        return true;
    }
    
    if (node->northWest == NULL) {
        MKQuadTreeNodeSubdivide(node);
    }
    
    if (MKQuadTreeNodeInsertData(node->northWest, data)) return true;
    if (MKQuadTreeNodeInsertData(node->northEast, data)) return true;
    if (MKQuadTreeNodeInsertData(node->southWest, data)) return true;
    if (MKQuadTreeNodeInsertData(node->southEast, data)) return true;
    
    return false;
}

void MKQuadTreeGatherDataInRange(MKQuadTreeNode* node, MKBoundingBox range, MKDataReturnBlock block)
{
    if (!MKBoundingBoxIntersectsBoundingBox(node->boundingBox, range)) {
        return;
    }
    
    for (int i = 0; i < node->count; i++) {
        if (MKBoundingBoxContainsData(range, node->points[i])) {
            block(node->points[i]);
        }
    }
    
    if (node->northWest == NULL) {
        return;
    }
    
    MKQuadTreeGatherDataInRange(node->northWest, range, block);
    MKQuadTreeGatherDataInRange(node->northEast, range, block);
    MKQuadTreeGatherDataInRange(node->southWest, range, block);
    MKQuadTreeGatherDataInRange(node->southEast, range, block);
}

void MKQuadTreeTraverse(MKQuadTreeNode* node, MKQuadTreeTraverseBlock block)
{
    block(node);
    
    if (node->northWest == NULL) {
        return;
    }
    
    MKQuadTreeTraverse(node->northWest, block);
    MKQuadTreeTraverse(node->northEast, block);
    MKQuadTreeTraverse(node->southWest, block);
    MKQuadTreeTraverse(node->southEast, block);
}

MKQuadTreeNode* MKQuadTreeBuildWithData(MKQuadTreeNodeData *data, int count, MKBoundingBox boundingBox, int capacity)
{
    MKQuadTreeNode* root = MKQuadTreeNodeMake(boundingBox, capacity);
    
    for (int i = 0; i < count; i++) {
        MKQuadTreeNodeInsertData(root, data[i]);
    }
    
    return root;
}

void MKFreeQuadTreeNode(MKQuadTreeNode* node)
{
    if (node->northWest != NULL) MKFreeQuadTreeNode(node->northWest);
    if (node->northEast != NULL) MKFreeQuadTreeNode(node->northEast);
    if (node->southWest != NULL) MKFreeQuadTreeNode(node->southWest);
    if (node->southEast != NULL) MKFreeQuadTreeNode(node->southEast);

    free(node->points);
    free(node);
}
